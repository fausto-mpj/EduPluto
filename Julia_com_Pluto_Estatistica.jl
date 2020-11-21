### A Pluto.jl notebook ###
# v0.11.2

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 9d996162-d41c-11ea-09b4-994ed99dd014


# ╔═╡ 9d3661fc-d41c-11ea-1997-175b6d9a4095


# ╔═╡ d5eaa180-d41b-11ea-32f6-6ff398c3e4c2
begin
	using LinearAlgebra
	using PlutoUI
	using StatsKit
	import Plots
	import StatsPlots
	
	md"""
	# Julia 102: Estatística com Pluto.jl
	
	Vamos explorar um pouco as distribuições e funções estatísticas no Julia. A primeira coisa a notar é que o Julia básico contém o [pacote](https://docs.julialang.org/en/v1/stdlib/Statistics/) `Statistics`, com operações bem simples como `mean()` e `cov()`, e o [pacote](https://docs.julialang.org/en/v1/stdlib/Random/) `Random`, para a geração de números (pseudo)aleatórios. No entanto, há todo um ambiente de computação estatística em desenvolvimento para a linguagem. Vamos utilizar o [meta-pacote](https://github.com/JuliaStats/StatsKit.jl) `StatsKit` que importa alguns dos principais pacotes estatísticos.
	
	Inicialmente, vamos explorar algumas funções e visualizações de interesse para a Estatística por meio das distribuicões univariadas do pacote [Distributions](https://juliastats.org/Distributions.jl/stable/univariate/).
	"""
end

# ╔═╡ 61be6a20-d41c-11ea-0eee-654e9ec43f39
begin
	md"""
	Vamos brincar um pouco com uma distribuição Normal na qual escolheremos os parâmetros μ e σ², comparando o seu gráfico com o da Normal Padrão.
	
	**Selecione o parâmetro μ da Normal**:
	
	$(@bind μ Slider(-50.0:0.1:50.0, 0)) 
	
	**Selecione o parâmetro σ² da Normal**:
	
	$(@bind σ² Slider(1:0.01:50.0))
	
	Acima podemos conferir o resultado, em que a Normal Padrão está em azul escuro e a nossa Normal está em vermelho. Note que o valor inicial de μ é `0` e o σ² é `1`, logo as curvas estão sobrepostas.
	"""
end

# ╔═╡ 517a652c-d41c-11ea-2118-fdbf45828452
md"""### Distribuição Normal
**Valor de μ**: $μ

**Valor de σ²**: $σ²
"""

# ╔═╡ 57bc858e-d41c-11ea-392b-f1c840845820
#Visualização das distribuições
begin
	Plots.plot(Normal(μ, σ²), color = :red, lw = 2, legend = false, fill = (0, :red), fillalpha = 0.5)
	Plots.plot!(Normal(0,1), color = :royalblue, lw = 2, legend = false, fill = (0, :royalblue), fillalpha = 0.5)
end

# ╔═╡ 664c20be-d41c-11ea-1467-e1c670479af6
begin
	
	x = rand(Normal(μ, σ²), 100)
	
	md"""
	Vamos agora gerar uma amostra aleatória de tamanho 100 da distribuição da nossa Normal(μ, σ²) usando o pacote `Random`. O comando está abaixo.
	
	
	
	
	"""
end

# ╔═╡ acc667f8-d59c-11ea-0805-41b21640540b
begin
	md"""
	Agora vejamos a distribuição LogNormal.
	
	**Selecione o parâmetro μₗ da LogNormal**:
	
	$(@bind μₗ Slider(0.0:0.1:25.0)) 
	
	**Selecione o parâmetro σ²ₗ da LogNormal**:
	
	$(@bind σ²ₗ Slider(0.01:0.01:5.0))
	
	Note que o valor inicial de μₗ é `1.0` e o σ²ₗ é `0.01`.
	"""
end

# ╔═╡ a3dc9324-d59c-11ea-3787-39b6dc720a4b
md"""### Distribuição LogNormal
**Valor de μₗ**: $μₗ

**Valor de σ²ₗ**: $σ²ₗ
"""

# ╔═╡ a651c700-d59c-11ea-029c-1d55b204a41c
#Visualização da distribuição
Plots.plot(LogNormal(μₗ, sqrt(σ²ₗ)), color = :red, lw = 2, legend = false, fill = (0, :red), fillalpha = 0.5)

# ╔═╡ 6ebf2016-d41c-11ea-1a8d-6566e98d1f34
begin
	md"""
	Agora vejamos a distribuição Gamma e o seu formato de acordo com os parâmetros k e θ, onde θ é o parâmetro de escala. Note que nesta parametrização, temos que a função de densidade é dada por
	
	\begin{equation}
	f(x| k, \theta) = \frac{x^{k-1} e^{-x/θ}}{\Gamma(k) \theta^{k}} \text{ ,} 
	\end{equation}
	
	para $x > 0$, $k > 0$ e $\theta > 0$.
	
	**Selecione o parâmetro k da Gamma**:
	
	$(@bind k Slider(1.0:0.1:25.0)) 
	
	**Selecione o parâmetro θ da Gamma**:
	
	$(@bind θ Slider(0.1:0.1:25.0))
	
	Novamente podemos conferir o resultado. Note que o valor inicial de k é `1.0` e o θ é `0.1`.
	"""
end

# ╔═╡ 6a7b3bf2-d41c-11ea-014e-8b94632190ff
md"""### Distribuição Gamma
**Valor de k**: $k

**Valor de θ**: $θ
"""

# ╔═╡ 6e2923fe-d41c-11ea-03d2-0956b986677c
#Visualização da distribuição
Plots.plot(Gamma(k, θ), color = :red, lw = 2, legend = false, fill = (0, :red), fillalpha = 0.5)

# ╔═╡ 801c622e-d41c-11ea-0441-e300c24904ae
begin
	md"""
	Agora a distribuição mais versátil de todas: a distribuição Beta e o seu formato de acordo com os parâmetros α e β. 
	
	**Selecione o parâmetro α da Beta**:
	
	$(@bind α Slider(0.1:0.1:10.0)) 
	
	**Selecione o parâmetro β da Beta**:
	
	$(@bind β Slider(0.1:0.1:10.0))
	
	Os valores iniciais de α e de Β são ambos `0.1`.
	"""
end

# ╔═╡ 6f79fbca-d41c-11ea-0c49-3ffd9d1d5ab2
md"""### Distribuição Beta
**Valor de α**: $α

**Valor de β**: $β
"""

# ╔═╡ 80571608-d41c-11ea-2e72-b7f20192a991
#Visualização da distribuição
Plots.plot(Beta(α, β), color = :red, lw = 2, legend = false, fill = (0, :red), fillalpha = 0.5)

# ╔═╡ 70188128-d41c-11ea-1e8f-5371e257a3bf
begin
	md"""
	Vemos agora a distribuição que ninguém se lembra como é a função de densidade: a distribuição Χ² e o seu formato de acordo com o parâmetro ν de graus de liberdade.
	
	**Selecione o parâmetro ν da Chi-Quadrado**:
	
	$(@bind ν Slider(1:50)) 
	
	O valor inicial de ν é `1` e só assume valores inteiros positivos.
	
	"""
end

# ╔═╡ 7fd8c4ce-d41c-11ea-0790-f7afc7a1a84d
#Verificando o valor do parâmetro
md"""
### Distribuição Chi-Quadrado
**Valor de ν**: $ν
"""

# ╔═╡ 7f661988-d41c-11ea-3167-753a433c34e3
#Visualização da distribuição
Plots.plot(Chisq(ν), color = :red, lw = 2, legend = false, fill = (0, :red), fillalpha = 0.5)

# ╔═╡ 9dcde59a-d41c-11ea-36ec-db54e9680172
begin
	md"""
	Como **com certeza** alguém disse na anterior que sabe sim a forma da função de densidade da Χ², então agora sim a distribuição cuja função de densidade que **ninguém** se lembra. Algum desafiante?
	
	**Selecione o parâmetro d₁ da F-Snedecor**:
	
	$(@bind d₁ Slider(1:50)) 
	
	**Selecione o parâmetro d₂ da F-Snedecor**:
	
	$(@bind d₂ Slider(1:50)) 
	
	Os valores iniciais de d₁ e d₂ são ambos `1`, e só assumem valores inteiros positivos.
	"""
end

# ╔═╡ 9bcc9a70-d41c-11ea-3235-0ffa6ccc0bd5
#Verificando o valor dos parâmetros
md"""
### Distribuição F-Snedecor
**Valor de d₁**: $d₁

**Valor de d₂**: $d₂
"""

# ╔═╡ 9dfe153a-d41c-11ea-2a80-79631819f1ac
#Visualização da distribuição
Plots.plot(FDist(d₁, d₂), color = :red, lw = 2, legend = false, fill = (0, :red), fillalpha = 0.5)

# ╔═╡ Cell order:
# ╠═d5eaa180-d41b-11ea-32f6-6ff398c3e4c2
# ╟─517a652c-d41c-11ea-2118-fdbf45828452
# ╟─57bc858e-d41c-11ea-392b-f1c840845820
# ╟─61be6a20-d41c-11ea-0eee-654e9ec43f39
# ╟─664c20be-d41c-11ea-1467-e1c670479af6
# ╟─a3dc9324-d59c-11ea-3787-39b6dc720a4b
# ╟─a651c700-d59c-11ea-029c-1d55b204a41c
# ╟─acc667f8-d59c-11ea-0805-41b21640540b
# ╟─6a7b3bf2-d41c-11ea-014e-8b94632190ff
# ╟─6e2923fe-d41c-11ea-03d2-0956b986677c
# ╟─6ebf2016-d41c-11ea-1a8d-6566e98d1f34
# ╟─6f79fbca-d41c-11ea-0c49-3ffd9d1d5ab2
# ╟─80571608-d41c-11ea-2e72-b7f20192a991
# ╟─801c622e-d41c-11ea-0441-e300c24904ae
# ╟─7fd8c4ce-d41c-11ea-0790-f7afc7a1a84d
# ╠═7f661988-d41c-11ea-3167-753a433c34e3
# ╟─70188128-d41c-11ea-1e8f-5371e257a3bf
# ╟─9bcc9a70-d41c-11ea-3235-0ffa6ccc0bd5
# ╟─9dfe153a-d41c-11ea-2a80-79631819f1ac
# ╟─9dcde59a-d41c-11ea-36ec-db54e9680172
# ╠═9d996162-d41c-11ea-09b4-994ed99dd014
# ╠═9d3661fc-d41c-11ea-1997-175b6d9a4095
