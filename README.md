<div align="center">
<h1><code>FastDedispersion.jl</code></h1>
<h4><i>The fast DM transform, in Julia.</i></h4>
<br/>

![License][license]
![GitHub Stars][stars]
[![Gitmoji Badge][gitmoji_badge]][gitmoji]

<br/>
</div>

<div align="justify">

This package implements the **fast DM transform** (**FDMT**) in pure Julia[^1]. Quoting from [**Zackay and Ofek (2014)**](https://iopscience.iop.org/article/10.3847/1538-4357/835/1/11), the original paper:

> The FDMT algorithm calculates the integral over all curves defined by $\Delta t = t _{2} - t _{1} = d (f _{1} ^{-2} - f _{2} ^{-2})$, where $d = D \times DM$, and $D$ is the dispersion constant. A dispersion curve can be uniquely defined by the arrival time of the signal at the lowest frequency ($t _{0}$) and the time delay between the arrival times of the lowest and highest frequencies ($\Delta t$). [...] To compute the FDMT transform of the input, the algorithm works in $\log _{2}(N _{f})$ iterations, where $N _{f}$ is the number of frequency channels.

Install it by typing and running:

```bash
] add FastDedispersion
```

in the Julia REPL.


Here is an example of the DM transform, obtained via `FastDedispersion.jl`, from 30 seconds of simulated FRB data. The FRB has a DM of 1000 pc cm $^{-3}$, and an arrival time of 5 seconds, and was dedispersed from 900 to 1100 pc cm $^{-3}$. Note that the plot is zoomed-in, so that we may easily see the expected bow-tie pattern:

<br/>

![Plot: Example dedispersed time series via FastDedispersion.jl](./assets/example_dmt.png)

The simulation was carried out using the [**`simulateSearch`**](https://bitbucket.csiro.au/projects/PSRSOFT/repos/simulatesearch/browse) library. The corresponding data file, in the SIGPROC filterbank format, is included in this package as a part of its testing suite [**here**](./test/data/frb.fil). If you are wondering how to read such files in Julia, you can do so via the [**`SIGPROCFiles.jl`**][SF] package.

[^1]: I follow the implementation as laid out in [**`pyfdmt`**][pyfdmt], written by [**Vincent Morello**][vincent]. This package implements the FDMT in Python, using recursion. This approach is different from the pseudocode provided in the original paper, and even the code in MATLAB and Python provided by the original authors, which use nested loops. As laid out in a private communication, he wrote this as he was working on the **fast folding algorithm** (**FFA**), and noticed the glaring similarities between it, the FDMT, and (of course) the **fast Fourier transform** (**FFT**).

</div>

[gitmoji]: https://gitmoji.dev
[vincent]: https://github.com/v-morello
[presto]: https://github.com/scottransom/presto
[pyfdmt]: https://bitbucket.org/vmorello/pyfdmt
[SF]: https://github.com/astrogewgaw/SIGPROCFiles.jl
[fdmtjl]: https://github.com/kiranshila/FastDMTransform.jl
[gitmoji_badge]: https://img.shields.io/badge/gitmoji-%20😜%20😍-FFDD67.svg?style=for-the-badge
[stars]: https://img.shields.io/github/stars/astrogewgaw/FastDedispersion.jl?style=for-the-badge
[license]: https://img.shields.io/github/license/astrogewgaw/FastDedispersion.jl?style=for-the-badge
