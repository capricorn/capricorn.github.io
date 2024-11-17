# Optimal Scraping Against Threshold Rate Limiters

A frequent problem when scraping a domain is _rate limiting._ That is, there is a maximum
rate at which pages can be requested. Exceeding this rate typically results in the server
blocking future requests until the rate is reduced; for instance, it may reply with an HTTP 400 response.

Of course, with some trial and error the programmer can determine a rate that is never limited and use that.
This strategy is hardly desirable if there are thousands of pages to scrape. Is there a way then to determine
what the rate may be? 

The following assumes the rate limiter in question is a _threshold_ limiter. If the request rate exceeds
a fixed threshold all future requests are ignored until the rate falls back below it.

A simple implementation of a threshold limiter could work as follows: upon arrival each request's unix timestamp
is appended to a sliding window $w$ of size $k>1$. The limiter fixes a threshold $\theta$, the max requests/sec.
The current requests/sec, $r$, is determined as follows:

\begin{align}
r &= (k-1)/(w_{k-1} - w_0)\\
\texttt{limit} &= r > \theta
\end{align}

With this in mind the programmer will select some $r$. The server provides binary feedback on this choice:
accept or limit. That is:

$$
\textit{limit}(r) = \begin{cases}
    0 & 0\leq r\leq \theta\\
    1 & r\gt \theta
\end{cases}
$$

...which is a nice monotonic function---perfect for binary search. 

In practice: first, select some sufficiently wide range of rates $[u,l]$ where $u=\epsilon$ (effectively zero, simpler math) and $l$ is large enough
to comfortably avoid rate limiting. Begin with the current rate $r=\epsilon$. In this model requests are considered instantaneous so these 'rates'
in this implementation are actually sec/request, i.e. seconds for use with `sleep(r)`{.python}---the reciprocal still establishes the desired rate.
Starting with the fastest rate is also logical: why not check the best solution first?

Next, select a reasonable $k$. If the window size is $j$ then clearly if $k\geq j$ and requests are made with rate $r$ the window itself should compute that rate (all the previous requests made at a different rate have cycled out.)

Finally, the binary search rules:

- Attempt $k$ requests with rate $r$.
- If the final request is rate limited, $r$ is too fast:
    1. Set $u=r$; any rate $a\leq u$ is too fast.
    2. Set $r=(l+r)/2$; slow $r$ down.
- Otherwise, if the final request is _not_ limited, $r$ is too slow:
    1. Set $l=r$; any rate $a\geq l$ is too slow.
    2. Set $r=(u+r)/2$; speed $r$ up.

Repeat the above process until $r$ reaches a fixed point---in practice rounding will need applied.


A Python simulation of the threshold limiter and above search strategy:

```python
_t = 0
EPSILON = 1/1e6

def time():
    return _t

def sleep(sec):
    global _t
    _t += sec

class Requester():
    WINDOW_SIZE = 5

    def __init__(self, max_requests_per_sec=1):
        self.max_requests_per_sec = max_requests_per_sec
        self.request_ts_window = []
    
    def reset(self):
        self.request_ts_window = []

    def request(self) -> bool:
        self.request_ts_window.append(time())
        if len(self.request_ts_window) < Requester.WINDOW_SIZE:
            return True
        
        req_per_sec = (Requester.WINDOW_SIZE-1)/(self.request_ts_window[-1] - self.request_ts_window[0])
        self.request_ts_window.pop(0)

        if req_per_sec > self.max_requests_per_sec:
            return False
        
        return True

req = Requester(max_requests_per_sec=3)

def k_req(time_betw_req) -> bool:
    k = Requester.WINDOW_SIZE
    result = True

    for _ in range(k):
        result = req.request()
        if time_betw_req > 0:
            sleep(time_betw_req)
        else:
            sleep(EPSILON)
    
    return result

# sec/req
l = 20
u = EPSILON # Avoid divide by zero difficulties -- close enough to 'instantaneous' 
r = EPSILON
prev_r = r

while True:
    if k_req(r):    # r too slow (or just right)
        l = r
        r = round((r+u)/2, 2)
        print(f'Too slow, increasing rate, r={r} [u={u}, l={l}]')
    else:   # r too fast
        u = r
        r = round((r+l)/2, 2)
        print(f'Too fast, decreasing rate, r={r} [u={u},l={l}]')
    
    if prev_r == r:
        break
    else:
        prev_r = r

print(f'Optimal r: {r:.2f}s {r**(-1):.2f} req/sec')
```

And the output for a limiter with a maximum of 3 req/sec:

```
Too fast, decreasing rate, r=10.0 [u=1e-06,l=20]
Too slow, increasing rate, r=5.0 [u=1e-06, l=10.0]
Too slow, increasing rate, r=2.5 [u=1e-06, l=5.0]
Too slow, increasing rate, r=1.25 [u=1e-06, l=2.5]
Too slow, increasing rate, r=0.63 [u=1e-06, l=1.25]
Too slow, increasing rate, r=0.32 [u=1e-06, l=0.63]
Too fast, decreasing rate, r=0.47 [u=0.32,l=0.63]
Too slow, increasing rate, r=0.4 [u=0.32, l=0.47]
Too slow, increasing rate, r=0.36 [u=0.32, l=0.4]
Too slow, increasing rate, r=0.34 [u=0.32, l=0.36]
Too slow, increasing rate, r=0.33 [u=0.32, l=0.34]
Too fast, decreasing rate, r=0.34 [u=0.33,l=0.34]
Too slow, increasing rate, r=0.34 [u=0.33, l=0.34]
Optimal r: 0.34s 2.94 req/sec
```

A few notes, other questions and other ideas:

- Understanding effects of rounding: the domain is effectively continuous and this certainly has implications w.r.t a valid solution, search steps etc.
- Different cooldown mechanism: a cooldown window $k$ minutes from the initial blocked request. If a request arrives in the interim the cooldown resets.
- For serial requests, factoring in the actual request time. This itself establishes an approximate ceiling rate.

## Addendum I

_11/16/24_

Consider the cumulative request count as a function of time, i.e. $c(t)$ is the total number of requests
in $t$ seconds from the initial request $t=0$. Once this request is made the limiter begins monitoring. 
Sometime later at $t_1$ the limit is exceeded. The attempted rate at $t_1$ is $c(t_1)/t_1$; so for $t>0$ the average rate is $r(t)=c(t)/t$.

Since no requests can be made while the rate limiter is active the rate begins to decay. With respect to $t_1$ this
would be $d(t)=c(t_1)/(t_1+t)$. A useful question in this case is to determine how many seconds until the rate decays
to some rate of interest $0<q<d(0)$. Solving for $t$ results in $t=\frac{c(t_1)}{q}-t_1$.

A concrete example: take the following sequence of $(t,c)$: $((0,0),(25,5))$. At $t=25$ the rate limiter applies
at 0.2 req/sec. How much time should the requester wait until the limiter considers the next request to be
at the rate 0.1 req/sec? $q=1/10$, $t_1=25$, $c(t_1)=5$; $t=5/0.1-25=25$. To check the work, waiting another
25 seconds would put the requests per sec at $5/50 = 0.1$.