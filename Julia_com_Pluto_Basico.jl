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

# ╔═╡ 7548fe76-b328-11ea-1dff-b16fc38e0cc5
#O comando md seguido de três aspas duplas inicia o modo Markdown, para fechá-lo basta usar novamente três aspas duplas.
md"""

# Julia 101: Básico interativo com Pluto.jl

Vamos começar falando de algumas coisas que só farão sentido depois de um tempo.

Como estamos usando o [Pluto.jl](https://github.com/fonsp/Pluto.jl), então cada célula deveria ser *atômica*, ou seja, conter somente uma atribuição ou operação. No entanto, em alguns casos, podemos fazer várias operações em uma mesma célula por meio de blocos de [*begin*](https://docs.julialang.org/en/v1/base/base/#begin) com `begin ... end` ou de [*let*](https://docs.julialang.org/en/v1/manual/variables-and-scoping/#Let-Blocks-1) com `let ... end`. Veremos mais detalhes sobre esses blocos mais adiante!

Para importar um pacote, usamos o comando `using` ou `import`. Em ambos os casos, estamos carregando e permitindo que os *nomes* contidos no pacote sejam visíveis e acessíveis a partir do nosso *espaço de nomes*. A [diferença](https://docs.julialang.org/en/v1/manual/modules/#modules-1) é principalmente quanto à disponibilidade dos *nomes* e acesso aos *tipos* contidos no pacote.

Ao usar `using`, traremos os *nomes* do pacote para o nosso *espaço de nomes*. Por outro lado, ao usarmos `import`, apenas permitiremos o acesso ao *espaço de nomes* do pacote por meio de prefixos. Ou seja, se o pacote `foo` contém a *função* `bar()`, então podemos chamar a *função* como `foo.bar()` por qualquer um dos métodos e como `bar()` somente se importamos `foo` por meio do `using`.

Portanto, o `using` é mais cômodo, no entanto pode trazer conflitos e não permite que uma *função* ou um *tipo* de um pacote sejam trivialmente alterados ou expandidos. No entanto, em geral não é necessário se preocupar, dado que qualquer conflito será notificado pelo compilador!

Dito isso, podemos importar alguns pacotes e começar com a introdução.
"""

# ╔═╡ 11bce208-d445-11ea-277d-d1f081a3f39f
begin
	md"""
	
	### Introdução: O que é o Julia?
	
	A linguagem [Julia](https://julialang.org/) é composta de 4 elementos centrais: **nomes**, **tipos**, **variáveis** e **valores**. Podemos apresentar a relação destes elementos em uma única frase: **Uma *variável* é um *nome* associado a um *valor* de um *tipo*.** A principal força do Julia vem do seu sistema de *tipos*.
	
	Afinal, o que é um *tipo*?
	
	Bem, *tipos* são formatos para armazenar informação de modo significativo. Para a máquina, não seria possível decidir que *tipo* de *valor* irá assumir uma sequência de *bits* antes de tê-la percorrido por inteiro. *Tipos* resolvem isso reservando alguns *bits* para indicar à máquina quais são os resultados possíveis que uma sequência de *bits* produzirá. Os **tipos primitivos** mais comuns no Julia são `Bool`, `Char`, `String`, `Int64` e `Float64`. Outros *tipos primitivos* podem ser vistos [aqui](https://docs.julialang.org/en/v1/manual/integers-and-floating-point-numbers/#Integers-and-Floating-Point-Numbers-1).
	
	O sistema de tipagem do Julia não contém somente *tipos primitivos*. Na realidade, há uma [árvore de tipos](https://docs.julialang.org/en/v1/manual/types/index.html) em que os *tipos folhas*, como os *tipos primitivos*, são ditos **tipos concretos**. Todos os demais *tipos* são ditos **tipos abstratos**. Cada *tipo* possui um único **supertipo** e somente *tipos* abstratos possuem **subtipos**. A única exceção à regra é o *tipo* `Any` que não possui um *supertipo*, sendo o *tipo* de maior hierarquia na linguagem. Como decorrência desta estrutura, dois *valores* de *tipos* distintos sempre podem encontrar o menor *supertipo* comum dentro da árvore. Além disso, **os *valores* são sempre de um *tipo concreto*.**
	
	Apesar do compilador ser capaz de inferir os *tipos* dos *valores* de cada variável, como em qualquer outra linguagem de tipagem dinâmica, o Julia opera de maneira mais eficiente quando utilizamos uma tipagem mais forte. Podemos fazer isso utilizando basicamente três instrumentos: a [função](https://docs.julialang.org/en/v1/base/base/#Core.typeof) `typeof()`, o [operador](https://docs.julialang.org/en/v1/manual/types/#Type-Declarations-1) `::` e o [construtor](https://docs.julialang.org/en/v1/base/base/#struct) `struct()`.
	
	A linguagem também utiliza um sistema de *despacho múltiplo*, na qual uma mesma *função* pode aplicar diferentes procedimentos a depender do *tipo* dos *valores* de entrada (*inputs*). O compilador é capaz de otimizar o código usando procedimentos mais específicos para os *tipos* de *valores* usados, levando a um ganho significativo de desempenho e melhora nas práticas de programação.
	"""
end

# ╔═╡ 4e8cda56-d37f-11ea-2044-f97c6be953de
begin
	md"""
	Agora que vimos um pouco sobre *nomes*, *tipos*, *variáveis* e *valores*, podemos explorar o último elemento básico: **funções**. O Julia é uma *linguagem funcional*, ou seja, a *função* é unidade básica de organização do código e a melhora do desempenho está intimamente relacionada com o quanto conseguimos discretizar o código em *funções* e evitar declarações de *variáveis* globais.
	
	Como vimos, pela característica de *despacho múltiplo*, uma *função* pode aceitar *valores* de entrada de diferentes *tipos* e usar um bloco de código específico para cada um. Esses blocos são chamados de *métodos* da *função*. Podemos ver os *métodos* por meio da [função](https://docs.julialang.org/en/v1/base/base/#Base.methods) `methods()`. Além disso, é possível definir e adicionar *métodos* às *funções* já existentes, bastando usar a sintaxe usual para a construção de *funções*:
	
	* Forma abreviada
	
	```
	function nomedafunção(x::<tipo>, y::<tipo> = <valor padrão>) = ...
	```
	
	* Forma completa
	
	```
	function nomedafunção(x::<tipo>, y::<tipo> = <valor padrão>)
		<comando_1>
		...
		<comando_n>
	end
	```
	
	Um novo *método* será adicionado à *função* caso não exista algum *método* para os *valores* dos *tipos* especificados. Além disso, *funções* podem ser *frutíferas* ou *infrutívera*, a depender se apresentarem ou não um *valor* de retorno por meio do [operador](https://docs.julialang.org/en/v1/base/base/#return) `return`.
	
	Vamos experimentar criar uma *função* com alguns *métodos*.
	"""
end

# ╔═╡ d1257c48-d500-11ea-2bcc-8925c4e468f6
md"""
Vejamos agora algumas operações lógicas e de comparação.

Note que para os *valores* do *tipo* `Bool`, Julia usa as palavras-chave `true` e `false`. Estas palavras são reservadas pelo Julia.

* Os operadores lógicos são `||`, `&&` e `!`, em ordem crescente de hierarquia.


* Os operadores de comparação são `>`, `≥` (`\geq <Tab>`) ou `>=`, `<`, `≤` (`\leq <Tab>`) ou `<=`, e `==`. Como exceção, existe o operador `≡` (`\equiv <Tab>`) ou `===` que irá checar se dois *valores* são iguais e possuem o mesmo *tipo*.


* Existem dois operadores `&` e `|` que são *bitwise AND* e *bitwise OR*. Estes operadores funcionam **somente** entre pares de números inteiros expressos em dígitos binários.

Se uma sentença conter operações aritméticas, lógicas e de comparação, então a ordem de avaliação será: aritmética, comparação e então lógica.

A regra de resolução de conflitos de ordem de operações segue o posto acima, com preferência para avaliar primeiro o que está dentro de parênteses e, ocorrendo empate de hierarquia de operações, realizando primeiro a operação mais à esquerda e indo em ordem até a operação mais à direita.
"""

# ╔═╡ 43ad0664-d3a3-11ea-2166-879e9399ead3
#Formas de se criar o mesmo vetor 3 × 1
[3, 1, 1]

# ╔═╡ 4bc35814-d386-11ea-22e1-e1e19f5a34d8
#Formas de se criar o mesmo vetor 3 × 1
[3; 1 ;1]

# ╔═╡ 37601e7e-d393-11ea-3abe-ef3da3e63de2
#Note no entanto que esse é um vetor 1 × 3
[3 1 1]

# ╔═╡ 490a365c-d3ee-11ea-3ac7-65cdebf1ac8d
#Criando um arranjo de arranjos, em que cada arranjo é uma linha de um vetor-coluna
[[1, 2, 3], [1 2 3]]

# ╔═╡ 3cd0dd4a-d407-11ea-328a-1dd685dc6ea2
md"""
Arranjos podem ter índices arbitrários ou que não representem o número e ordem dos seus elementos. Mais detalhes [aqui](https://docs.julialang.org/en/v1/devdocs/offset-arrays/#man-custom-indices-1).
"""

# ╔═╡ 4b7a5266-d3fd-11ea-3493-2d952e1fb5ba
md"""

Uma peculiaridade do Pluto.jl é que a atualização automática só ocorre quando alguma variável *imutável* é alterada. Logo, se `x = 2` e alteramos o programa para que `x = 3`, o Pluto.jl atualizará todas as células que contenham referência à variável x.

No entanto, os elementos do arranjos são *mutáveis*, então se mudarmos algum elemento do arranjo não teremos atualização automática. Isso só ocorrerá se mudarmos a própria variável do arranjo, ou seja:

* Não irá ativar a reatividade: `x = [1, 2, 3] ; x[1] = 2 #[2, 2, 3]`.


* Irá ativar a reatividade: `x = [1, 2, 3], x = [2, 2, 3] #[2, 2, 3]`.

Lembrem-se, no entanto, que **não** é possível múltiplas atribuições de valor à mesma variável em células diferentes!
"""

# ╔═╡ d6f2fe18-d3e6-11ea-17f6-3baada805cce
md"""
* Operações comuns entre **vetores** usando o `LinearAlgebra`, supondo `x` e `y` vetores com dimensões apropriadas e `c` um escalar:

1) [Adição](https://docs.julialang.org/en/v1/base/math/#Base.:+): `x + y`, ou `+(x, y)`;


2) [Subtração](https://docs.julialang.org/en/v1/base/math/#Base.:--Tuple{Any,Any}): `x - y`, ou `-(x, y)`;


3) [Multiplicação](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/#LinearAlgebra.lmul!) por escalar: `c * x`, ou `*(c, x)`, ou `x .* c`, ou `lmul!(c, x)`;


4) Adição por escalar: `x + c * ones(length(x))` ou `x .+ c`;


5) [Transposição](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#Base.transpose): `x'`, ou `transpose(x)`;


6) [Produto interno](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/#LinearAlgebra.dot) ($x^{T} y$): `dot(x, y)`, ou `x . y` (⋅ feito com `\cdot <Tab>`);


7) [Produto](https://docs.julialang.org/en/v1/base/math/#Base.:*-Tuple{Any,Vararg{Any,N}%20where%20N}) matricial ($x y$): `x * y`;


8) [Produto cruzado](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/#LinearAlgebra.cross) ($x \times y$): `cross(x, y)`, ou `x × y` (× feito com `\times <Tab>`, somente com vetores 3 × 1);


9) [Norma](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#LinearAlgebra.norm): `norm(x)`;


10) Distância: `norm(x - y)`;


11) [Normalização](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#LinearAlgebra.normalize) $\left(\frac{x}{||x||}\right)$: `normalize(x)`;


12) [Somatório](https://docs.julialang.org/en/v1/base/collections/#Base.sum) $\left(\sum^{n}_{i = 1} x_{i}\right)$: `sum(x)`;


13) [Média](https://docs.julialang.org/en/v1/stdlib/Statistics/#Statistics.mean): `mean(x)`, no entanto, neste caso, a função estão no [pacote](https://docs.julialang.org/en/v1/stdlib/Statistics/) básico `Statistics`.


* Operações comuns entre **matrizes** usando o `LinearAlgebra`, supondo `A` e `B` matrizes com dimensões apropriadas, `x` vetor com dimensões apropriadas e `c` um escalar:

1) [Adição](https://docs.julialang.org/en/v1/base/math/#Base.:+): `A + B`, ou `+(A, B)`;


2) [Subtração](https://docs.julialang.org/en/v1/base/math/#Base.:--Tuple{Any,Any}): `A - B`, ou `-(A, B)`;


3) [Transposição](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#Base.transpose): `A'`, ou `transpose(A)`;


4) [Inversão](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#Base.inv-Tuple{AbstractArray{T,2}%20where%20T}): `inv(A)`;


5) [Pseudo-inversa de Moore-Penrose](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#LinearAlgebra.pinv): `pinv(A)`;


6) [Multiplicação](https://docs.julialang.org/en/v1/base/math/#Base.:*-Tuple{Any,Vararg{Any,N}%20where%20N}) por escalar: `c * A`, ou `*(c, A)`;


7) [Multiplicação](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/#LinearAlgebra.mul!) por vetor ($Ax$): `A * x`, ou `*(A, x)`, ou `mul!(Y, A, x)`;


8) [Multiplicação](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/#LinearAlgebra.mul!) por matriz ($AB$): `A * B`, ou `*(A, B)`, ou `mul!(Y, A, B)`;


9) [Exponenciação](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/#Base.:^-Tuple{AbstractArray{T,2}%20where%20T,Number}) ($A^{c}$): `A^c`;


10) [Determinante](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#LinearAlgebra.det) $\left(|A|\right)$: `det(A)`;


11) [Log-determinante](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#LinearAlgebra.logdet) $\left(ln(|A|)\right)$: `logdet(A)`;


12) [Log-determinante absoluto](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#LinearAlgebra.logabsdet) $\left(ln(||A||)\right)$: `logabsdet(A)`;


13) Soma da coluna $\left(\sum_{m \in M} a_{m,n}\right)$: `sum(A, dims = 1)`, atente que o arranjo resultante é um arranjo-linha;


14) Soma da linha $\left(\sum_{n \in N} a_{m,n}\right)$: `sum(A, dims = 2)`, atente que o arranjo resultante é um arranjo-coluna;


15) [Traço](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#LinearAlgebra.tr) $\left(tr(A)\right)$: `tr(A)`;


16) [Espaço Nulo](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#LinearAlgebra.nullspace): `nullspace(A)`.


* Fatorações e decomposições comuns entre **matrizes** usando o `LinearAlgebra`:

1. A [função](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#LinearAlgebra.eigen) `eigen()` executa a [decomposição por autovalores](https://en.wikipedia.org/wiki/Eigendecomposition_of_a_matrix). Os seus atributos são `values` e `vectors`, contendo os autovalores e autovetores da matriz. Podemos acessar os atributos por meio da notação `.`: `D = eigen(A) ; D.values # [λ₁, ..., λₙ]`.


2. A [função]() `svd()` executa a [decomposição por valores singulares](https://pt.wikipedia.org/wiki/Decomposi%C3%A7%C3%A3o_em_valores_singulares). Os seus atributos são `U`, `S`, `V` e `Vt`, onde `U` é uma matriz unitária real ou complexa, `S` é um vetor com números reais não-negativos e `Vt` é uma matriz unitária real ou complexa, de modo que `A = U * Diagonal(S) * Vt`.


3. A [função](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#LinearAlgebra.lu) `lu()` executa a [decomposição LU](https://pt.wikipedia.org/wiki/Decomposi%C3%A7%C3%A3o_LU). Os seus atributos são `L`, `U`, `p` e `P`, onde `L` é a matriz triangular inferior, `U` é a matriz triangular superior, `p` é o vetor de permutação à direita e `P` é a matriz de permutação à direita.


4. A [função](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#LinearAlgebra.cholesky) `cholesky()` executa a [fatoração de Cholesky](https://pt.wikipedia.org/wiki/Fatora%C3%A7%C3%A3o_de_Cholesky). Os seus atributos são `L` e `U`, onde `U` é a transposta de `L`.


5. A [função](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#LinearAlgebra.qr) `qr()` executa a [decomposição QR](https://en.wikipedia.org/wiki/QR_decomposition). Os seus atributos são `Q` e `R`.


6. A [função](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#LinearAlgebra.schur) `shur()` executa a [decomposição de Shur](https://en.wikipedia.org/wiki/Schur_decomposition). Os seus atributos são `T`, `Z` e `values`, onde `T` é o fator (quase) triagunlar de Shur, `Z` é a matriz ortogonal dos vetores de Shur e `values` é o vetor dos autovalores.


Como o Julia utiliza dispacho múltiplo, é interessante checar a documentação para verificar o que as funções retornam e seus parâmetros. Por exemplo, é especialmente importante checar sobre a função `pinv()` pelo seu papel no método dos mínimos quadrados.

"""

# ╔═╡ 9e6b5a0e-d454-11ea-3cd8-69b687166340
#A tralha ("hashtag") permite escrever comentário no corpo do código
#Carregando os pacotes
begin
	using LinearAlgebra
	using Statistics
	using PlutoUI
	import Plots
end

# ╔═╡ 5e55de14-d452-11ea-20bd-114c97ba4df2
#Verificando o tipo do valor 1
typeof(1)

# ╔═╡ 4589e708-d453-11ea-15f4-7f4efb68b159
#Verificando o supertipo de Int64
supertype(typeof(1))

# ╔═╡ 0a5f13f0-d454-11ea-2fb9-f3b15278c9ee
#Verificando o supertipo de Signed
supertype(supertype(typeof(1)))

# ╔═╡ 244d9106-d454-11ea-2672-6d3da0d2fff6
#Verificando o supertipo de Integer
supertype(supertype(supertype(typeof(1))))

# ╔═╡ ab8b9182-d453-11ea-1ddb-89717ea927fb
#Verificando o tamanho em bytes do Int64
Base.summarysize(1)

# ╔═╡ 3a4d9dee-d453-11ea-1024-9d8b156212c7
#Verificado o tipo do valor 2.5
typeof(1 + 1.5)

# ╔═╡ 7d0cf292-d453-11ea-34d8-4bd8ff8b925c
#Verificando o supertipo de Float64
supertype(typeof(1 + 1.5))

# ╔═╡ 18ca704c-d454-11ea-1900-bf83468082d0
#Verificando o supertipo de AbstractFloat
supertype(supertype(typeof(1 + 1.5)))

# ╔═╡ cd2754ca-d453-11ea-0c1e-0507fd4a323c
#Verificando o tamanho em bytes do Float64
Base.summarysize(1 + 1.5)

# ╔═╡ c34df1f0-d455-11ea-09e3-c9982355f070
#Verificando o tipo do nothing
typeof(nothing)

# ╔═╡ 499979dc-d456-11ea-1c5c-27988e76b40a
#Verificando o tipo do nothing
supertype(typeof(nothing))

# ╔═╡ 3c66adf2-d456-11ea-2503-89147b7afded
#Verificando o tipo de um arranjo [1, 2, 3]
typeof([1, 2, 3])

# ╔═╡ cc640950-d455-11ea-1700-79b264b0bb2c
#Verificando o supertipo de Array{Int64, 1}
supertype(typeof([1, 2, 3]))

# ╔═╡ 8a721040-d456-11ea-3625-63fcaaf109d2
#Verificando o supertipo de DenseArray{Int64, 1}
supertype(supertype(typeof([1, 2, 3])))

# ╔═╡ 98e5f79a-d456-11ea-036f-6148262b7d68
#Verificando o tamanho em bytes da Array{Int64, 1}
Base.summarysize([1, 2, 3])

# ╔═╡ ba514512-d378-11ea-2baa-9d3ed72cec53
begin
	
	a = 10.0
	
	md"""
	
	### 1. Operações básicas
	
	O *nome* de uma *variável* pode conter qualquer caracter [Unicode](https://en.wikipedia.org/wiki/List_of_Unicode_characters), no entanto não pode começar com um dígito. Por convenção, *variáveis* e *funções* começam com letras minúsculas, enquanto *tipos* começam com letras maiúsculas. Os seguintes *nomes* são reservados e não podem ser usados como *nome* de variáveis: `abstract type`, `baremodule`, `begin`, `break`, `catch`, `const`, `continue`, `do`, `else`, `elseif`, `end`, `export`, `false`, `finally`, `for`, `function`, `global`, `if`, `import`, `importall`, `in`, `let`, `local`, `macro`, `module`, `mutable struct`, `primitive type`, `quote`, `return`, `true`, `try`, `using`, `struct`, `where`, `while`. Não é necessário decorar essa lista, dado que, na maior parte dos IDEs, esses *nomes* serão coloridos de modo a diferenciá-los dos demais.
	
	Um caracter Unicode que não tenha um comando usual do teclado pode ser inserido por meio de [abreviações](https://docs.julialang.org/en/v1/manual/unicode-input/#) semelhantes a do LaTeX seguidas de `Tab`. Por exemplo: a letra grega gama maiúsculo, `Γ`, é obtida digitando `\Gamma`, seguido da tecla `Tab`. Mais interessante do que isso, a tartaruga 🐢 é obtida digitando `\:turtle:`, seguido da tecla `Tab`.
	
	A atribuição do *valor* à *variável* se dá por meio do operador `=`, onde o *nome* da *variável* estará sempre à esquerda da igualdade. Abaixo, na célula de código, vamos atribuir à *variável* de *nome* `a` o *valor* `10.0` do *tipo* `Float64`.
	
	> a = 10.0
	"""
end

# ╔═╡ e1125f26-d37b-11ea-1eff-816c70048c72
#Verificando o valor da variável a
a

# ╔═╡ 4aa9ef08-d390-11ea-2d2d-a1538323a05d
#Verificando o tipo da variável a
typeof(a)

# ╔═╡ 3edc3ff6-d461-11ea-0bbf-8788f190f750
#Criando uma função com vários métodos
begin
	function função_adicionar(x::Number, y::Number)
		return(x+y)
	end
	
	function função_adicionar(x::Number, y::String)
		dic = Dict("um"=> 1, "dois" => 2, "três" => 3, "quatro" => 4, "cinco" =>5, "seis"=> 6, "sete" => 7, "oito" => 8, "nove" => 9)
		return(x + dic[lowercase(y)])
	end
	
	function função_adicionar(x::String, y::Number)
		dic = Dict("um"=> 1, "dois" => 2, "três" => 3, "quatro" => 4, "cinco" =>5, "seis"=> 6, "sete" => 7, "oito" => 8, "nove" => 9)
		return(y + dic[lowercase(x)])
	end
	
	function função_adicionar(x::String, y::String)
		dic = Dict("um" => 1, "dois" => 2, "três" => 3, "quatro" => 4, "cinco" =>5,"seis"=> 6, "sete" => 7, "oito" => 8, "nove" => 9)
		return(dic[lowercase(x)] + dic[lowercase(y)])
	end
	
	function função_adicionar(x::Char, y::String)
		dic = Dict("um"=> 1, "dois" => 2, "três" => 3, "quatro" => 4, "cinco" =>5, "seis"=> 6, "sete" => 7, "oito" => 8, "nove" => 9)
		return(parse(Int64,x) + dic[lowercase(y)])
	end
	
	function função_adicionar(x::String, y::Char)
		dic = Dict("um"=> 1, "dois" => 2, "três" => 3, "quatro" => 4, "cinco" =>5, "seis"=> 6, "sete" => 7, "oito" => 8, "nove" => 9)
		return(parse(Int64,y) + dic[lowercase(x)])
	end
	
	function função_adicionar(x::Number, y::Char)
		return(x + parse(Int64,y))
	end
	
	function função_adicionar(x::Char, y::Number)
		return(y + parse(Int64,x))
	end
	
	function função_adicionar(x::Char, y::Char)
		return(parse(Int64,x) + parse(Int64,y))
	end
end

# ╔═╡ 4b2e3e5e-d465-11ea-37b0-87f8a3d719b6
#Vendo os métodos da função_adicionar()
methods(função_adicionar)

# ╔═╡ 4f8ce150-d466-11ea-3d3b-612a86a20dd5
#Usando os vários métodos da função
função_adicionar('5',5) + função_adicionar('5',"cinco") + função_adicionar("cinco",5)

# ╔═╡ 7283abe8-d467-11ea-3097-3b063f8a3ca3
begin
	md"""
	Vejamos algumas [operações e funções](https://docs.julialang.org/en/v1/manual/mathematical-operations/) básicas com escalares. Para isso vamos usar uma nova variável.
	
	**Selecione o *valor* de 🐢 na barra de correr abaixo**:
	
	$(@bind 🐢 Slider(-25.0:0.01:25.0)) 
	
	Observe que em todas as células abaixo os *valores* de 🐢 são atualizados, com estado inicial igual a `-25`. Além disso, vemos que 🐢 é do *tipo* `Int64` no seu estado inicial. No entanto, ao alterar o *valor*, o *tipo* pode mudar para `Float64`.
	
	Se levarmos a barra ao outro extremo, no *valor* igual a `25`, veremos que ocorrerá uma [promoção](https://docs.julialang.org/en/v1/manual/conversion-and-promotion/) automática em que o *tipo* do *valor* de 🐢 será convertido para `Int64`. Isso não é o usual. Geralmente, somente ocorrerá o contrário, dado que qualquer número inteiro tem uma representação em ponto flutuante, mas nem todo ponto flutuante terá uma representação em número inteiro.
	
	Logo abaixo temos o gráfico de uma função
	
	\begin{equation}
	f(x) = sen\left( \frac{x}{b} \right) \text{ ,}
	\end{equation}
	
	onde $$x \in [0,30]$$ e $$b$$ como a nossa tartaruga.
	"""
end

# ╔═╡ 71e90f4a-d467-11ea-14ea-8ddad3ed52b3
#Verificando o valor da variável b
md"""

**Valor de 🐢**: $🐢

**Tipo da variável 🐢**: $(typeof(🐢))
"""

# ╔═╡ 94563de6-d381-11ea-08f4-fbfeaf4cc4d5
#Vamos brincar um pouco com uma visualização
#As funções trigonométricas como sin(), cos() e tan() usam como entrada radianos!
begin
	println("Vamos chamar o $🐢")
	f(x, b = 🐢) = sin(x / b)
	Plots.plot(f, 0:0.01:30, legend = false)
end

# ╔═╡ 25960f18-d380-11ea-1a4b-f9ba52963806
#Soma
a + 🐢

# ╔═╡ 2c61bc66-d380-11ea-1a6e-5dc74f8e39c6
#Subtração
a - 🐢

# ╔═╡ 328fa512-d380-11ea-0509-edff01e88423
#Multiplicação
a * 🐢

# ╔═╡ 36e87f44-d380-11ea-0632-6fafa86b2ba2
#Divisão com a no numerador e b no denominador
a / 🐢

# ╔═╡ 3fa8d246-d380-11ea-2195-bd3862da65f0
#Divisão com b no numerador e a no denominador
a \ 🐢

# ╔═╡ 5a3e856a-d380-11ea-25e5-f9bcb219d70e
#Potenciação
a^🐢

# ╔═╡ 6b1f3104-d380-11ea-3f61-b3aa1408c4d9
#Divisão inteira de a por b: div ou ÷ (\div <Tab>)
div(a, 🐢)

# ╔═╡ 0ff9a65a-d381-11ea-2eb5-c3d6dc0e7cf1
#Mesmo acima
a ÷ 🐢

# ╔═╡ 9fc3a96c-d380-11ea-2d22-c3b0f3800736
#Resto da divisão inteira de a por b: mod, rem ou %
mod(a, 🐢)

# ╔═╡ c2a6e6f6-d380-11ea-2848-e765432972dd
#Mesmo acima
a % 🐢

# ╔═╡ d91246be-d381-11ea-22d3-bb8b8ce382c8
#Representação como racional de a / b
rationalize(a / 🐢)

# ╔═╡ 982d5204-d3e4-11ea-3feb-6d17061562d5
#Checar uma igualdade com == 
#Neste caso, verifica se referem-se aos mesmos valores
a == 🐢

# ╔═╡ f2d99db2-d409-11ea-363d-1d58daadc79a
#Checar uma equivalência com ≡ (\equiv <Tab>) ou ===
a ≡ 10

# ╔═╡ f898ebd8-d409-11ea-39a8-c5bf1392e99b
#Checar uma igualdade com ==
a == 10

# ╔═╡ 73dca420-d3e4-11ea-2437-e5e894e94587
#Checar uma desigualdade com ≠ (\ne <Tab>)
a ≠ 🐢

# ╔═╡ 3c9b3894-d382-11ea-32cc-1f075f8fff54
#Comparação se a é maior ou igual (\geq <Tab>) ao b
a ≥ 🐢

# ╔═╡ 0af09224-d389-11ea-115e-4ba278ee876a
#Comparação dupla usando menor ou igual (\leq <Tab>)
0 ≤ a ≤ 🐢

# ╔═╡ 573f4b9c-d38a-11ea-137e-cfbf238c3d14
begin
	
	c = Vector([10.0; 15.0; 20.0])
	
	md"""
	
	### 2. Operações vetoriais
	
	O [construtor](https://docs.julialang.org/en/v1/base/arrays/#Core.Array) `Array()`, junto ao operador relacionado `[]`, criará um *arranjo-coluna*. O delimitador padrão entre os elementos de arranjos unidimensionais é a vírgula (`,`), no entanto, em arranjos com mais dimensões, o delimitador para concatenar elementos na horizontal é o espaço em branco, enquanto que para concatenar elementos na vertical é o ponto-e-vírgula (`;`). Para criar arranjos $n$-dimensionais, pode ser necessário usar o parâmetro de dimensão no comando `Array{<Tipo>, <n>}([<dados>], (<nᵒ de elementos d₁>, ..., <nᵒ de elementos dₙ>))`.
	
	O arranjo é uma estrutura de dados *mutável* e *indexável* que pode ser fatiado pela notação de colchete: `x = [1, 2, 3, 4]; x[2:end] #[2,3,4]`. Note que `end` é um argumento de índice que indica o último elemento de um objeto. Além disso, é possível criar peridiciocidade no fatiamento por meio de um terceiro parâmetro: `x[<começo>:<passo>:<fim>]`. Também podemos usar o [operador](https://docs.julialang.org/en/v1/base/math/#Base.::) `:` para criar uma amplitude (*range*).
	
	Vetores também podem ser concatenados verticalmente com a [função](https://docs.julialang.org/en/v1/base/arrays/#Base.vcat) `vcat(<vetor1>, <vetor2>)` ou horizontalmente com a [função](https://docs.julialang.org/en/v1/base/arrays/#Base.hcat) `hcat(<vetor1>, <vetor2>)`. As funções exigem que os vetores tenham dimensões compatíveis ou retornarão erro.
	
	Caso os elementos sejam iteráveis ou uma amplitude (*range*), então o delimitador usado mudará o resultado final de maneira drástica.

	Espaçoem branco implicará que cada coluna será ocupada pelos elementos da amplitude, ou seja, a primeira coluna será dos termos da primeira amplitude, a segunda coluna será dos termos da segunda amplitude *etc*.;
	
	1. Vírgula(`,`) implicará que os próprios objetos de amplitude serão os elementos em um vetor-coluna;

	
	2. Ponto-e-vírgula(`;`) implicará que haverá uma única coluna com os elementos da amplitude, serão colocados um abaixo do outro seguindo a ordem.
	
	
	Uma mistura destes separadores pode ser usada para gerar algum efeito desejado. Por exemplo, `m6 = [1:3 4:6; 7:9 10:12]` gerará uma matriz com primeira coluna composta pelo vetor `[1, 2, 3, 7, 8, 9]` e a segunda coluna composta pelo vetor `[4, 5, 6, 10, 11, 12]`.

	Julia é uma linguagem *column-major*, ou seja, as estruturas de dados $n$-dimensionais são acessadas "verticalmente", seguindo as colunas. Assim, se `m1` é uma matriz $M$ 2 × 2, então `m1[1]` é o elemento $m_{1,1}$, `m1[2]` é o elemento $m_{2,1}$, `m1[3]` é o elemento $m_{1,2}$ e `m1[4]` é o elemento $m_{2,2}$ da matriz.
	
	Abaixo, na célula de código, vamos atribuir à variável `c` o arranjo 3 × 1 com elementos `[10.0; 10.0; 10.0]` do tipo `Array{Float64, 1}`. De maneira geral, em operações matemáticas, o Julia tratará arranjos como vetores. Para declarar explicitamente um arranjo é do *tipo* vetor, podemos usar o [construtor](https://docs.julialang.org/en/v1/base/arrays/#Base.Vector) `Vector()`. No caso de arranjos bidimensionais, podemos fazer o mesmo para o *tipo* matriz por meio do [construtor](https://docs.julialang.org/en/v1/base/arrays/#Base.Matrix) `Matrix()`.
	"""
end

# ╔═╡ dea4dd2c-d3e2-11ea-00ff-8d164680707f
#Verificando o valor da variável c
c

# ╔═╡ ac7996ba-d3ff-11ea-1c9e-754c7b9af8af
#Verificando o tipo da variável c
typeof(c)

# ╔═╡ abb5b982-d408-11ea-070a-3d2163c19406
#Note que se criarmos um vetor d com os mesmos valores, teremos outro objeto
d = Vector([10.0, 15.0, 20.0])

# ╔═╡ c01277a6-d408-11ea-0dd5-317c0ee3cf6e
#Verificando se c e d são equivalentes com ≡ (\equiv <Tab>) ou ===
c ≡ d

# ╔═╡ d71ce17a-d408-11ea-3e1d-39bc64921448
#Verificando se c e d são idênticos com == 
c == d

# ╔═╡ 4852ed98-d40a-11ea-326b-5bc4cb41ef1c
#Note que agora somente estamos dando um outro nome ao mesmo objeto
e = c

# ╔═╡ 6b204b2a-d40a-11ea-12c2-6bb7734bee65
#Verificando se c e e são equivalentes com ≡ (\equiv <Tab>) ou ===
c ≡ e

# ╔═╡ 70a6b630-d40a-11ea-2598-4752fbd46e78
#Verificando se c e e são idênticos com == 
c == e

# ╔═╡ e25ec324-d38a-11ea-24ce-f7113692e2db
#Formas de se criar o mesmo vetor 3 × 1
Array([3, 1, 1])

# ╔═╡ 9779777c-b329-11ea-3b3b-47ed2b4cf59c
#Criando uma matriz identidade A com dimensões 3x3
A = Matrix([2 0 0; 0 1 0; 0 0 1])

# ╔═╡ 4290aa8c-d3a4-11ea-1177-ff69a45735b0
#Verificando o tipo de A
typeof(A)

# ╔═╡ 698ac79a-d3a8-11ea-0efb-9da5e7268b34
#Primeira coluna de A
A[:, 1]

# ╔═╡ c8a7b4b8-d3a8-11ea-1cd7-c7dfa1be6c49
#A primeira linha de A
A[1, :]

# ╔═╡ 2e1bad0e-d3a9-11ea-3b66-2f70af73242f
#Criando arranjo bimensional com os elementos de iteradores como colunas
[2:4 7:9 12:14]

# ╔═╡ 33d37e94-d3ee-11ea-2ae1-958b308a8113
#Criando um arranjo com iteradores como elementos
[2:4, 3:5, 4:6]

# ╔═╡ 345fbf30-d3ee-11ea-2a55-e1ad67b68838
#Criando um arranjo com os elementos de iteradores como uma única coluna
[2:4; 3:5; 4:6]

# ╔═╡ 5213eae6-d3e2-11ea-04bd-b1b48fe6f533
begin
	B = Matrix{Float64}(undef, 2, 2)
	
	md"""
	O pacote `LinearAlgebra` do Julia básico contém alguns construtores, operadores e funções especializados para Álgebra Linear, como, por exemplo, `I` para gerar uma matriz identidade de dimensão arbitrária. A documentação do pacote pode ser encontrada [aqui](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/) e é recomendado que qualquer pessoa com interesse em computação matemática se familiarize com este pacote. 
	
	Algumas funções especialmente importantes para a manipulação de arranjos são:
	
	* A [função](https://docs.julialang.org/en/v1/base/arrays/#Base.ndims) `ndims()` retorna o número de dimensões de um arranjo n-dimensional.
	
	
	* A [função](https://docs.julialang.org/en/v1/base/arrays/#Base.length-Tuple{AbstractArray}) `length()` retorna o número de elementos de um arranjo.
	
	
	* A [função](https://docs.julialang.org/en/v1/base/arrays/#Base.size) `size()` retorna o comprimento de cada dimensão de um arranjo.
	
	
	* A [função](https://docs.julialang.org/en/v1/base/arrays/#Base.zeros) `zeros()` retorna um arranjo com todas as entradas nulas com a dimensão desejada.
	
	
	* A [função](https://docs.julialang.org/en/v1/base/arrays/#Base.ones) `ones()` retorna um arranjo com todas as entradas iguais a 1 com a dimensão desejada.
	
	
	* A [função](https://docs.julialang.org/en/v1/base/arrays/#Base.reshape) `reshape(<objeto>, (<dimensões>))` permite alterar as dimensões de um arranjo. Deste modo, se `v2 = [1 2 3]` é um arranjo 1x3, então podemos transformá-lo em um arranjo 3x1 com o comando `reshape(v2, (3, 1))`.
	
	
	* O [construtor](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/#LinearAlgebra.Diagonal) `Diagonal()` construirá uma matriz diagonal n × n se for passado um arranjo n × 1 como argumento. 
	
	
	* A [função](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#LinearAlgebra.diag) `diag()` extrairá a diagonal de uma matriz, retornando-a como um arranjo.
	
	
	É possível pré-alocar valores arbitrários em um arranjo para que a estrutura tenha as dimensões correta por meio de `undef`. Por exemplo, podemos criar uma matriz 2 × 2 de elementos do tipo `Float64` com `Matrix{Float64}(undef, 2, 2)`. As [constantes](https://docs.julialang.org/en/v1/base/arrays/#Core.undef) `undef` irão utilizar valores que estejam disponíveis na memória ou marcados para serem removidos pelo *garbage collector* como *placeholders*.
	
	Além disso, há um [operador](https://docs.julialang.org/en/v1/manual/mathematical-operations/#man-dot-operators-1) *dot* (`.`) para funções escalares que aplicam a função a cada elemento de um arranjo. Por exemplo: `cos.(A)` aplica a função `cos()` a todos os elementos da matriz $A$.
	"""
end

# ╔═╡ 3f99ff12-d3eb-11ea-11f3-5b5df7549571
#Verificando o valor da variável B
B

# ╔═╡ b62ed4c0-d3fc-11ea-2370-2fd698ef96ae
#Vamos atribuir alguns valores para os elementos de B
begin
	B[1] = 1
	B[2] = rand(0:10, 1)[1]
	B[:,2] = rand(0:10, 2)
	B
end

# ╔═╡ 6e286974-d411-11ea-3fe9-f3c3ae0dc280
#Vejamos o comprimento de B
length(B)

# ╔═╡ 71b3d632-d411-11ea-0e22-0d78174b087d
#Vejamos o tamanho de B
size(B)

# ╔═╡ 744cdbbe-d411-11ea-2c98-8fc6abc6f4ee
##Vejamos o número de dimensões de B
ndims(B)

# ╔═╡ ac7bfdf4-d40b-11ea-1fa1-3beb6ee6ca54
#Extraindo a diagonal de B
diag(B)

# ╔═╡ eaa83194-d3eb-11ea-0478-79370e80b20b
#Subtraindo 1 dos elementos da matriz B
B .- 1

# ╔═╡ aa47de40-d410-11ea-09a5-15ab5bf763f0
#Subtraindo 1 somente dos elementos fora da diagonal de B
B - ones(size(B)) + I

# ╔═╡ eeba65e8-d401-11ea-0a37-d32e0ac61cc9
#Multiplicando cada um dos elementos de B por 2
B .* 2

# ╔═╡ f7ba275a-d401-11ea-1b89-fdfd7e1c48bc
#Note que neste caso é o mesmo que simplesmente multiplicar a matriz por um escalar
B * 2

# ╔═╡ 7b85d7ba-d3eb-11ea-1dd3-3b5f8a105916
#Aplicando sin() aos elementos matriz [1 0; 0 1] multiplicados por 3π/2
sin.(3π/2 .* B)

# ╔═╡ ea4d1a52-d3f5-11ea-01b3-0f58262e6d9e
#Note que é igual ao seno da matriz somente porque a matriz é quadrada!
sin(3π/2 .* B)

# ╔═╡ 20703f8a-d3f6-11ea-03aa-f7adfb9e3654
#Aplicando sin() aos elementos matriz 3 × 2 [1 0; 0 1; 2 2] multiplicados por 3π/2
sin.(3π/2 .* [1 0; 0 1; 2 2])

# ╔═╡ 0daccb54-d3ed-11ea-109f-3d6315ab66b5
#Elevando cada elemento da matriz ao quadrado
(B .- 1).^ 2

# ╔═╡ 21fcc64a-d3ed-11ea-15dc-d35654f03f99
#Note que usualmente é diferente da matriz ao quadrado!
(B .- 1)^2

# ╔═╡ 75a9c00c-d3f6-11ea-1205-19aad70fa1d9
begin
	md"""
	
	Selecione abaixo os valores para atribuirmos à nossa matriz $M$. Note que inicialmente a matriz será uma matriz de elementos `Int64`, no entanto se optarmos por colocar algum número com casa decimal, imediatamente será convertida em uma matriz de elementos `Float64`. Os valores permitidos estão no intervalo $[-100, 100]$.
	
	**Primeira linha**: $(@bind m1 html"<input type ='number', min = '-100', max = '100', value = '1', size = '1'>")
	$(@bind m4 html"<input type ='number', min = '-100', max = '100', value = '0', size = '1'>")
	$(@bind m7 html"<input type ='number', min = '-100', max = '100', value = '0', size = '1'>")
	
	
	**Segunda linha**: $(@bind m2 html"<input type ='number', min = '-100', max = '100', value = '0', size = '1'>")
	$(@bind m5 html"<input type ='number', min = '-100', max = '100', value = '1', size = '1'>")
	$(@bind m8 html"<input type ='number', min = '-100', max = '100', value = '0', size = '1'>")
	
	
	**Terceira linha**: $(@bind m3 html"<input type ='number', min = '-100', max = '100', value = '0', size = '1'>")
	$(@bind m6 html"<input type ='number', min = '-100', max = '100', value = '0', size = '1'>")
	$(@bind m9 html"<input type ='number', min = '-100', max = '100', value = '1', size = '1'>")
	"""
end

# ╔═╡ efaf99ba-d3f8-11ea-2eab-9d3cae4f8697
#Criando uma matriz 3 × 3
begin
	M = [m1 m4 m7; m2 m5 m8; m3 m6 m9] 
	
	md"""
	
	Vamos criar uma matriz interativa e realizar alguns testes sobre suas propriedades. A nossa primeira matriz será 3 × 3. As funções que usaremos serão:
	
	* A [função](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/#LinearAlgebra.issymmetric) `issymmetric()` para testar se uma matriz é simétrica.
	
	
	* A [função](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/#LinearAlgebra.isposdef) `isposdef()` para testar se uma matriz é positiva definida. Esse teste é realizado tentando aplicar a fatoração Cholesky e checando o resultado com `issuccess()`.
	
	
	* As [funções](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/#LinearAlgebra.istril) `istril()` e `istriu()` para testar se uma matriz é triangular inferior ou superior, respectivamente.
	
	
	* A [função](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/#LinearAlgebra.isdiag) `isdiag()` para testar se uma matriz é diagonal.
	
	
	* A [função](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/#LinearAlgebra.ishermitian) `ishermitian()` para testar se uma matriz é Hermitiana.
	
	
	* A [função](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/#LinearAlgebra.checksquare) `checksquare()` para testar se uma matriz é quadrada, retornando a dimensão comum.
	
	
	* A [função](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#LinearAlgebra.rank) `rank()` retorna o posto da matriz.
	
	Também podemos verificar se uma variável é um dos elementos de um arranjo por meio do [operador](https://docs.julialang.org/en/v1/base/collections/#Base.in) `∈` (`\in <Tab>`) ou `in`. Caso a ordem esteja inversa, podemos usar o operador inverso `∋` (`\ni <Tab>`). Deste modo, tomanto a variável como `a` e o arranjo como `c`: `a ∈ c` é equivalente a `c ∋ a`. A negação desta relação é dada pelo [operador](https://docs.julialang.org/en/v1/base/collections/#Base.:%E2%88%89) `∉` (`\notin <Tab>`), com inverso `∌` (`\nni <Tab>`).
	
	Após os testes, veremos algumas operações e decomposições de matrizes.
	"""
end

# ╔═╡ 393945e8-d3f9-11ea-1003-5f6dfe66e9e7
#Visualizando a matriz M
M

# ╔═╡ d672b758-d3fa-11ea-0741-25003cc6bb63
#Testando se M é simétrica
issymmetric(M)

# ╔═╡ e094a62e-d3fa-11ea-2f92-71c3a1bd739b
#Testando se M é positiva definida
isposdef(M)

# ╔═╡ e9db294e-d3fa-11ea-2d1e-8fb2c74f307c
#Testando se M é triangular superior
istriu(M)

# ╔═╡ f41fac98-d3fa-11ea-1438-9125dfcc7ceb
#Testando se M é diagonal
isdiag(M)

# ╔═╡ fd9b0132-d3fa-11ea-0dd7-591bbcedb9eb
#Testando se M é Hermitiana
ishermitian(M)

# ╔═╡ cad69f28-d3f9-11ea-3001-b9ae34a6d095
#Checando se a matriz é quadrada e retornando a dimensão comum
LinearAlgebra.checksquare(M)

# ╔═╡ 5a71ae82-d401-11ea-250a-f9833e649895
#Checando se a matriz é quadrada e retornando a dimensão comum
LinearAlgebra.checksquare(B)

# ╔═╡ 47fb5076-d40d-11ea-2add-e315e0284c6d
#Checando o posto da matriz M
rank(M)

# ╔═╡ 72de5950-d417-11ea-0dd7-09aed198885b
#Checando se a matriz M contém o número 1
1 ∈ M

# ╔═╡ 7cf8b9da-d417-11ea-0194-25f516dcac23
#Checando se a matriz M não contém o número 1
1 ∉ M

# ╔═╡ 867adb1e-d417-11ea-3478-f98e26ecfb77
#Note que é o mesmo que usar o operador de negação ! na expressão inteira
!(1 ∈ M)

# ╔═╡ 13e69962-d401-11ea-2876-19822449cec5
#Lembrando do valor de c
c

# ╔═╡ 1c63b770-d401-11ea-350b-6182e0a78a13
#Lembrando do valor de c
A

# ╔═╡ 86c24c9a-d400-11ea-2291-3f47ae05b0d7
#Realizando o produto A * x
A * c

# ╔═╡ 8aa49656-d400-11ea-2805-19d2558de524
#Criando um vetor x_t com dimensões 1x3, transposto x com a função transpose()
c_t = transpose(c)

# ╔═╡ 8e79a7f8-d400-11ea-2e6d-772aceae30c6
#Mesma coisa que utilizar o operador ' para transpor um arranjo, vetor ou matriz
c'

# ╔═╡ 963e8e68-d400-11ea-04f0-59a9f4991015
#Verificando o tipo de x_t
typeof(c_t)

# ╔═╡ a3ce9d7a-d400-11ea-2f6c-a9d649b816b6
#Transposta de A
M_t = M'

# ╔═╡ a89e8a40-d400-11ea-377d-75be788e91cf
#Realizando o produto x_t * A
c_t * M

# ╔═╡ abd800a6-d400-11ea-219f-99d3f4fd501f
#Vamos verificar se é o caso de (Ac)' == c_t A_t
(M * c)' == c_t * M_t

# ╔═╡ c92d4c7c-d3a8-11ea-30a8-fb9f07f3bf83
#A constante I utiliza matriz identidade de tamanho arbitrário
c_t * I

# ╔═╡ 2e753018-d3a9-11ea-3ef5-054db5875158
#O operador ⋅ (\cdot ,<Tab>) realiza o produto interno
c_t ⋅ c

# ╔═╡ 2e60c100-d3a9-11ea-2a0d-e182a55603ca
#Dependendo do contexto, o mesmo será feito com o operador *
c_t * c

# ╔═╡ 2e4b0f2c-d3a9-11ea-131f-6f0ed0af20c1
#Nem sempre será o caso! A multiplicação de um vetor 3 × 1 por um 1 × 3 gera uma matriz
c * c_t

# ╔═╡ 2e33f544-d3a9-11ea-21d4-317b43764db9
#E o produto escalar destes mesmo vetores ainda gera o resultado de xt * x
c ⋅ c_t

# ╔═╡ 22b97952-d401-11ea-1971-57b730a767fd
#Inversa do produto (M_t M)
inv((M_t * M))

# ╔═╡ 2dff201c-d3a9-11ea-29fa-d3ffa50117a3
#Usando a fatoração Cholesky se a matriz M for positiva definida
begin
	if isposdef(M)
		cholesky(M)
	end
end

# ╔═╡ 2dc1df34-d3a9-11ea-1bd4-dd0b5a9b8fb7
#Usando a decomposição espectral. Note que os autovalores retornam como vetor 3 × 1
eigen(M)

# ╔═╡ Cell order:
# ╟─7548fe76-b328-11ea-1dff-b16fc38e0cc5
# ╠═9e6b5a0e-d454-11ea-3cd8-69b687166340
# ╟─11bce208-d445-11ea-277d-d1f081a3f39f
# ╠═5e55de14-d452-11ea-20bd-114c97ba4df2
# ╠═4589e708-d453-11ea-15f4-7f4efb68b159
# ╠═0a5f13f0-d454-11ea-2fb9-f3b15278c9ee
# ╠═244d9106-d454-11ea-2672-6d3da0d2fff6
# ╠═ab8b9182-d453-11ea-1ddb-89717ea927fb
# ╠═3a4d9dee-d453-11ea-1024-9d8b156212c7
# ╠═7d0cf292-d453-11ea-34d8-4bd8ff8b925c
# ╠═18ca704c-d454-11ea-1900-bf83468082d0
# ╠═cd2754ca-d453-11ea-0c1e-0507fd4a323c
# ╠═c34df1f0-d455-11ea-09e3-c9982355f070
# ╠═499979dc-d456-11ea-1c5c-27988e76b40a
# ╠═3c66adf2-d456-11ea-2503-89147b7afded
# ╠═cc640950-d455-11ea-1700-79b264b0bb2c
# ╠═8a721040-d456-11ea-3625-63fcaaf109d2
# ╠═98e5f79a-d456-11ea-036f-6148262b7d68
# ╟─ba514512-d378-11ea-2baa-9d3ed72cec53
# ╠═e1125f26-d37b-11ea-1eff-816c70048c72
# ╠═4aa9ef08-d390-11ea-2d2d-a1538323a05d
# ╟─4e8cda56-d37f-11ea-2044-f97c6be953de
# ╠═3edc3ff6-d461-11ea-0bbf-8788f190f750
# ╠═4b2e3e5e-d465-11ea-37b0-87f8a3d719b6
# ╠═4f8ce150-d466-11ea-3d3b-612a86a20dd5
# ╟─71e90f4a-d467-11ea-14ea-8ddad3ed52b3
# ╟─7283abe8-d467-11ea-3097-3b063f8a3ca3
# ╟─94563de6-d381-11ea-08f4-fbfeaf4cc4d5
# ╠═25960f18-d380-11ea-1a4b-f9ba52963806
# ╠═2c61bc66-d380-11ea-1a6e-5dc74f8e39c6
# ╠═328fa512-d380-11ea-0509-edff01e88423
# ╠═36e87f44-d380-11ea-0632-6fafa86b2ba2
# ╠═3fa8d246-d380-11ea-2195-bd3862da65f0
# ╠═5a3e856a-d380-11ea-25e5-f9bcb219d70e
# ╠═6b1f3104-d380-11ea-3f61-b3aa1408c4d9
# ╠═0ff9a65a-d381-11ea-2eb5-c3d6dc0e7cf1
# ╠═9fc3a96c-d380-11ea-2d22-c3b0f3800736
# ╠═c2a6e6f6-d380-11ea-2848-e765432972dd
# ╠═d91246be-d381-11ea-22d3-bb8b8ce382c8
# ╟─d1257c48-d500-11ea-2bcc-8925c4e468f6
# ╠═982d5204-d3e4-11ea-3feb-6d17061562d5
# ╠═f2d99db2-d409-11ea-363d-1d58daadc79a
# ╠═f898ebd8-d409-11ea-39a8-c5bf1392e99b
# ╠═73dca420-d3e4-11ea-2437-e5e894e94587
# ╠═3c9b3894-d382-11ea-32cc-1f075f8fff54
# ╠═0af09224-d389-11ea-115e-4ba278ee876a
# ╟─573f4b9c-d38a-11ea-137e-cfbf238c3d14
# ╠═dea4dd2c-d3e2-11ea-00ff-8d164680707f
# ╠═ac7996ba-d3ff-11ea-1c9e-754c7b9af8af
# ╠═abb5b982-d408-11ea-070a-3d2163c19406
# ╠═c01277a6-d408-11ea-0dd5-317c0ee3cf6e
# ╠═d71ce17a-d408-11ea-3e1d-39bc64921448
# ╠═4852ed98-d40a-11ea-326b-5bc4cb41ef1c
# ╠═6b204b2a-d40a-11ea-12c2-6bb7734bee65
# ╠═70a6b630-d40a-11ea-2598-4752fbd46e78
# ╠═e25ec324-d38a-11ea-24ce-f7113692e2db
# ╠═43ad0664-d3a3-11ea-2166-879e9399ead3
# ╠═4bc35814-d386-11ea-22e1-e1e19f5a34d8
# ╠═37601e7e-d393-11ea-3abe-ef3da3e63de2
# ╠═9779777c-b329-11ea-3b3b-47ed2b4cf59c
# ╠═4290aa8c-d3a4-11ea-1177-ff69a45735b0
# ╠═698ac79a-d3a8-11ea-0efb-9da5e7268b34
# ╠═c8a7b4b8-d3a8-11ea-1cd7-c7dfa1be6c49
# ╠═2e1bad0e-d3a9-11ea-3b66-2f70af73242f
# ╠═33d37e94-d3ee-11ea-2ae1-958b308a8113
# ╠═345fbf30-d3ee-11ea-2a55-e1ad67b68838
# ╠═490a365c-d3ee-11ea-3ac7-65cdebf1ac8d
# ╟─3cd0dd4a-d407-11ea-328a-1dd685dc6ea2
# ╟─5213eae6-d3e2-11ea-04bd-b1b48fe6f533
# ╠═3f99ff12-d3eb-11ea-11f3-5b5df7549571
# ╟─4b7a5266-d3fd-11ea-3493-2d952e1fb5ba
# ╠═b62ed4c0-d3fc-11ea-2370-2fd698ef96ae
# ╠═6e286974-d411-11ea-3fe9-f3c3ae0dc280
# ╠═71b3d632-d411-11ea-0e22-0d78174b087d
# ╠═744cdbbe-d411-11ea-2c98-8fc6abc6f4ee
# ╠═ac7bfdf4-d40b-11ea-1fa1-3beb6ee6ca54
# ╠═eaa83194-d3eb-11ea-0478-79370e80b20b
# ╠═aa47de40-d410-11ea-09a5-15ab5bf763f0
# ╠═eeba65e8-d401-11ea-0a37-d32e0ac61cc9
# ╠═f7ba275a-d401-11ea-1b89-fdfd7e1c48bc
# ╠═7b85d7ba-d3eb-11ea-1dd3-3b5f8a105916
# ╠═ea4d1a52-d3f5-11ea-01b3-0f58262e6d9e
# ╠═20703f8a-d3f6-11ea-03aa-f7adfb9e3654
# ╠═0daccb54-d3ed-11ea-109f-3d6315ab66b5
# ╠═21fcc64a-d3ed-11ea-15dc-d35654f03f99
# ╟─efaf99ba-d3f8-11ea-2eab-9d3cae4f8697
# ╠═393945e8-d3f9-11ea-1003-5f6dfe66e9e7
# ╟─75a9c00c-d3f6-11ea-1205-19aad70fa1d9
# ╠═d672b758-d3fa-11ea-0741-25003cc6bb63
# ╠═e094a62e-d3fa-11ea-2f92-71c3a1bd739b
# ╠═e9db294e-d3fa-11ea-2d1e-8fb2c74f307c
# ╠═f41fac98-d3fa-11ea-1438-9125dfcc7ceb
# ╠═fd9b0132-d3fa-11ea-0dd7-591bbcedb9eb
# ╠═cad69f28-d3f9-11ea-3001-b9ae34a6d095
# ╠═5a71ae82-d401-11ea-250a-f9833e649895
# ╠═47fb5076-d40d-11ea-2add-e315e0284c6d
# ╠═72de5950-d417-11ea-0dd7-09aed198885b
# ╠═7cf8b9da-d417-11ea-0194-25f516dcac23
# ╠═867adb1e-d417-11ea-3478-f98e26ecfb77
# ╟─d6f2fe18-d3e6-11ea-17f6-3baada805cce
# ╠═13e69962-d401-11ea-2876-19822449cec5
# ╠═1c63b770-d401-11ea-350b-6182e0a78a13
# ╠═86c24c9a-d400-11ea-2291-3f47ae05b0d7
# ╠═8aa49656-d400-11ea-2805-19d2558de524
# ╠═8e79a7f8-d400-11ea-2e6d-772aceae30c6
# ╠═963e8e68-d400-11ea-04f0-59a9f4991015
# ╠═a3ce9d7a-d400-11ea-2f6c-a9d649b816b6
# ╠═a89e8a40-d400-11ea-377d-75be788e91cf
# ╠═abd800a6-d400-11ea-219f-99d3f4fd501f
# ╠═c92d4c7c-d3a8-11ea-30a8-fb9f07f3bf83
# ╠═2e753018-d3a9-11ea-3ef5-054db5875158
# ╠═2e60c100-d3a9-11ea-2a0d-e182a55603ca
# ╠═2e4b0f2c-d3a9-11ea-131f-6f0ed0af20c1
# ╠═2e33f544-d3a9-11ea-21d4-317b43764db9
# ╠═22b97952-d401-11ea-1971-57b730a767fd
# ╠═2dff201c-d3a9-11ea-29fa-d3ffa50117a3
# ╠═2dc1df34-d3a9-11ea-1bd4-dd0b5a9b8fb7
