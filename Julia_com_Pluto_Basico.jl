### A Pluto.jl notebook ###
# v0.19.11

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 9e6b5a0e-d454-11ea-3cd8-69b687166340
#A tralha ("hashtag") permite escrever comentário no corpo do código
#Carregando os pacotes
begin
	using LinearAlgebra
	using Statistics
	using PlutoUI
	import Plots
end

# ╔═╡ f23b2bd5-8d24-4b91-b6ae-937fca943fbd
PlutoUI.TableOfContents(aside=true)

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
	
	Bem, *tipos* são formatos para armazenar informação de modo significativo. Para a máquina, não seria possível decidir que *tipo* de *valor* irá assumir uma sequência de *bits* antes de tê-la percorrido por inteiro. *Tipos* resolvem isso reservando alguns *bits* para indicar à máquina quais são os resultados possíveis que uma sequência de *bits* produzirá. Os **tipos primitivos** mais comuns no Julia são `Bool` (booleano), `Char` (caracter), `String` (literal), `Int64` (inteiro de 64 bits) e `Float64` (ponto flutuante de 64 bits). Outros *tipos primitivos* podem ser vistos [aqui](https://docs.julialang.org/en/v1/manual/integers-and-floating-point-numbers/#Integers-and-Floating-Point-Numbers-1).
	
	O sistema de tipagem do Julia não contém somente *tipos primitivos*. Na realidade, há uma [árvore de tipos](https://docs.julialang.org/en/v1/manual/types/index.html) em que os *tipos folhas*, como os *tipos primitivos*, são ditos **tipos concretos**. Todos os demais *tipos* são ditos **tipos abstratos**. Cada *tipo* possui um único **supertipo** e somente *tipos* abstratos possuem **subtipos**. A única exceção à regra é o *tipo* `Any` que não possui um *supertipo*, sendo o *tipo* de maior hierarquia na linguagem. Como decorrência desta estrutura, dois *valores* de *tipos* distintos sempre podem encontrar o menor *supertipo* comum dentro da árvore. Além disso, **os *valores* são sempre de um *tipo concreto*.**
	
	Apesar do compilador ser capaz de inferir os *tipos* dos *valores* de cada variável, como em qualquer outra linguagem de tipagem dinâmica, o Julia opera de maneira mais eficiente quando utilizamos uma tipagem mais forte. Podemos fazer isso utilizando basicamente três instrumentos: a [função](https://docs.julialang.org/en/v1/base/base/#Core.typeof) `typeof()`, o [operador](https://docs.julialang.org/en/v1/manual/types/#Type-Declarations-1) `::` e o [construtor](https://docs.julialang.org/en/v1/base/base/#struct) `struct()`.
	
	A linguagem também utiliza um sistema de *despacho múltiplo*, na qual uma mesma *função* pode aplicar diferentes procedimentos a depender do *tipo* dos *valores* de entrada (*inputs*). O compilador é capaz de otimizar o código usando procedimentos mais específicos para os *tipos* de *valores* usados, levando a um ganho significativo de desempenho e melhora nas práticas de programação.
	"""
end

# ╔═╡ 5e466b68-163d-4942-96ce-bfd6077788ce
md"""
#### Exemplo 1: Usando `typeof`"""

# ╔═╡ 5e55de14-d452-11ea-20bd-114c97ba4df2
#Verificando o tipo do valor 1
typeof(1)

# ╔═╡ 3a4d9dee-d453-11ea-1024-9d8b156212c7
#Verificado o tipo do valor 2.5
typeof(1 + 1.5)

# ╔═╡ 3c66adf2-d456-11ea-2503-89147b7afded
#Verificando o tipo de um vetor [1, 2, 3]
typeof([1, 2, 3])

# ╔═╡ c34df1f0-d455-11ea-09e3-c9982355f070
#Verificando o tipo do nothing
typeof(nothing)

# ╔═╡ 78495249-e827-41b4-b130-c9d2bac743e6
md"""
#### Exemplo 2: Usando `supertype` $\circ$ `typeof`"""

# ╔═╡ 4589e708-d453-11ea-15f4-7f4efb68b159
#Verificando o supertipo de Int64
supertype(typeof(1))

# ╔═╡ 7d0cf292-d453-11ea-34d8-4bd8ff8b925c
#Verificando o supertipo de Float64
supertype(typeof(1 + 1.5))

# ╔═╡ cc640950-d455-11ea-1700-79b264b0bb2c
#Verificando o supertipo de Array{Int64, 1}
supertype(typeof([1, 2, 3]))

# ╔═╡ 499979dc-d456-11ea-1c5c-27988e76b40a
#Verificando o tipo do nothing
supertype(typeof(nothing))

# ╔═╡ be28b162-90eb-43c8-baa2-6bd333b5a1c8
md"""
#### Exemplo 3: Usando (`supertype`)² $\circ$ `typeof`"""

# ╔═╡ 0a5f13f0-d454-11ea-2fb9-f3b15278c9ee
#Verificando o supertipo de Signed
supertype(supertype(typeof(1)))

# ╔═╡ 18ca704c-d454-11ea-1900-bf83468082d0
#Verificando o supertipo de AbstractFloat
supertype(supertype(typeof(1 + 1.5)))

# ╔═╡ 8a721040-d456-11ea-3625-63fcaaf109d2
#Verificando o supertipo de DenseArray{Int64, 1}
supertype(supertype(typeof([1, 2, 3])))

# ╔═╡ c5c73409-2d40-4e97-8b41-7226076a300e
md"""
#### Exemplo 4: Usando (`supertype`)³ $\circ$ `typeof`"""

# ╔═╡ 244d9106-d454-11ea-2672-6d3da0d2fff6
#Verificando o supertipo de Integer
supertype(supertype(supertype(typeof(1))))

# ╔═╡ b103a520-5719-4da3-b25f-e2b538afca29
md"""
#### Exemplo 5: Usando `summarysize`"""

# ╔═╡ ab8b9182-d453-11ea-1ddb-89717ea927fb
#Verificando o tamanho em bytes do Int64
Base.summarysize(1)

# ╔═╡ cd2754ca-d453-11ea-0c1e-0507fd4a323c
#Verificando o tamanho em bytes do Float64
Base.summarysize(1 + 1.5)

# ╔═╡ 98e5f79a-d456-11ea-036f-6148262b7d68
#Verificando o tamanho em bytes da Array{Int64, 1}
Base.summarysize([1, 2, 3])

# ╔═╡ ba514512-d378-11ea-2baa-9d3ed72cec53
begin
	md"""
	
	### 1. Variáveis e nomes
	
	O *nome* de uma *variável* pode conter qualquer caracter [Unicode](https://en.wikipedia.org/wiki/List_of_Unicode_characters), no entanto não pode começar com um dígito. Por convenção, *variáveis* e *funções* começam com letras minúsculas, enquanto *tipos* começam com letras maiúsculas. Os seguintes *nomes* são reservados e não podem ser usados como *nome* de variáveis: `abstract type`, `baremodule`, `begin`, `break`, `catch`, `const`, `continue`, `do`, `else`, `elseif`, `end`, `export`, `false`, `finally`, `for`, `function`, `global`, `if`, `import`, `importall`, `in`, `let`, `local`, `macro`, `module`, `mutable struct`, `primitive type`, `quote`, `return`, `true`, `try`, `using`, `struct`, `where`, `while`. Não é necessário decorar essa lista, dado que, na maior parte dos IDEs, esses *nomes* serão coloridos de modo a diferenciá-los dos demais.
	
	Um caracter Unicode que não tenha um comando usual do teclado pode ser inserido por meio de [abreviações](https://docs.julialang.org/en/v1/manual/unicode-input/#) semelhantes a do LaTeX seguidas de `Tab`. Por exemplo: a letra grega gama maiúsculo, `Γ`, é obtida digitando `\Gamma`, seguido da tecla `<Tab>`. Mais interessante do que isso, a tartaruga 🐢 é obtida digitando `\:turtle:`, seguido da tecla `<Tab>`.
	
	A atribuição do *valor* à *variável* se dá por meio do operador `=`, onde o *nome* da *variável* estará sempre à esquerda da igualdade. Abaixo, na célula de código, vamos atribuir às *variáveis* de *nome* `a` e `b` valores numéricos.
	"""
end

# ╔═╡ fd08e20a-88c2-4723-abfc-0f8192cac8f6
# Atribuindo à variável `a` o valor `5`
a = 6

# ╔═╡ f81a7bb1-ff2e-4a55-8d04-f4cb651abb38
# Atribuindo à variável `b` o valor `2`
b = 2

# ╔═╡ 1117fc83-4c8b-4a01-b609-4af17cf7d36a
md"""
#### Exemplo 1.1: Usando o Julia como uma calculadora

Vamos estabelecer **$a$ = $a**, **$b$ = $b** e **$l = a \cdot b$**. Qual o valor de $l$?

Para alterar uma célular de comando, basta clicar na caixa de texto e editar livremente. Para rodar o código da célular, pressione `<Shift-Enter>` ou clique no botão com uma seta (▶️) no canto inferior direito da caixa de texto.
"""

# ╔═╡ 867971b1-765a-4315-af7a-f7b3d296999b
# Edite o valor de `l` para corresponder ao valor igual a `a * b`
l = 10

# ╔═╡ 4e8cda56-d37f-11ea-2044-f97c6be953de
begin
	md"""

	### 2. Funções
	
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

# ╔═╡ 3edc3ff6-d461-11ea-0bbf-8788f190f750
#Criando uma função com vários métodos
begin
	# Método para adicionar dois números
	function função_adicionar(x::Number, y::Number)
		return(x+y)
	end

	# Método para adicionar um número e um literal
	function função_adicionar(x::Number, y::String)
		dic = Dict("um"=> 1, "dois" => 2, "três" => 3, "quatro" => 4, "cinco" =>5, "seis"=> 6, "sete" => 7, "oito" => 8, "nove" => 9)
		return(x + dic[lowercase(y)])
	end

	# Método para adicionar um literal e um número
	function função_adicionar(x::String, y::Number)
		dic = Dict("um"=> 1, "dois" => 2, "três" => 3, "quatro" => 4, "cinco" =>5, "seis"=> 6, "sete" => 7, "oito" => 8, "nove" => 9)
		return(y + dic[lowercase(x)])
	end

	# Método para adicionar dois literais
	function função_adicionar(x::String, y::String)
		dic = Dict("um" => 1, "dois" => 2, "três" => 3, "quatro" => 4, "cinco" =>5,"seis"=> 6, "sete" => 7, "oito" => 8, "nove" => 9)
		return(dic[lowercase(x)] + dic[lowercase(y)])
	end

	# Método para adicionar um caracter e um literal
	function função_adicionar(x::Char, y::String)
		dic = Dict("um"=> 1, "dois" => 2, "três" => 3, "quatro" => 4, "cinco" =>5, "seis"=> 6, "sete" => 7, "oito" => 8, "nove" => 9)
		return(parse(Int64,x) + dic[lowercase(y)])
	end

	# Método para adicionar um literal e um caracter
	function função_adicionar(x::String, y::Char)
		dic = Dict("um"=> 1, "dois" => 2, "três" => 3, "quatro" => 4, "cinco" =>5, "seis"=> 6, "sete" => 7, "oito" => 8, "nove" => 9)
		return(parse(Int64,y) + dic[lowercase(x)])
	end

	# Método para adicionar um número e um caracter
	function função_adicionar(x::Number, y::Char)
		return(x + parse(Int64,y))
	end

	# Método para adicionar um caracter e um número
	function função_adicionar(x::Char, y::Number)
		return(y + parse(Int64,x))
	end

	# Método para adicionar dois caracteres
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

	### 3. Operações básicas
	
	Vejamos algumas [operações e funções](https://docs.julialang.org/en/v1/manual/mathematical-operations/) básicas com escalares. Para isso vamos usar uma nova variável.
	
	**Selecione o *valor* de 🐢 na barra de correr abaixo**:
	
	$(@bind 🐢 Slider(-25.0:0.01:25.0)) 
	
	Observe que em todas as células abaixo os *valores* de 🐢 são atualizados, com estado inicial igual a `-25.0`. Além disso, vemos que 🐢 é do *tipo* `Float64` no seu estado inicial. Às vezes uma variável pode ser [*promovida*](https://docs.julialang.org/en/v1/manual/conversion-and-promotion/) e mudar de tipo no decorrer de uma computação, no entanto é desejável que as variáveis sejam estáveis quanto ao tipo.
	
	A promoção mais usual é de `Int64` para `Float64`, dado que qualquer número inteiro tem uma representação em ponto flutuante. Como o contrário não é verdadeiro, e nem todo ponto flutuante terá uma representação em número inteiro, então é incomum a promoção em sentido contrário.

	#### Exemplo 3.1: Gráfico interativo
	
	Logo abaixo temos o gráfico de uma função

	$$
	\begin{equation}
	f(x) = sen\left( \frac{x}{b} \right) \text{ ,}
	\end{equation}
	$$
	
	onde $$x \in [0,30]$$ e $$b$$ a nossa tartaruga.
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

# ╔═╡ 8525f9c9-2d02-42c5-895b-b082b97dcfb4
md"""
#### Exemplo 3.2: Usando operações básicas

Lembrando que $a$ = $a e 🐢 = $🐢, como estabelecidos nas células anteriores. Temos as seguintes operações básicas com seus operadores:

"""

# ╔═╡ 25960f18-d380-11ea-1a4b-f9ba52963806
#Soma com operador `+`
a + 🐢

# ╔═╡ 2c61bc66-d380-11ea-1a6e-5dc74f8e39c6
#Subtração com o operador `-`
a - 🐢

# ╔═╡ 328fa512-d380-11ea-0509-edff01e88423
#Multiplicação com o operador `*`
a * 🐢

# ╔═╡ 36e87f44-d380-11ea-0632-6fafa86b2ba2
#Divisão com a no numerador e b no denominador com o operador `/`
a / 🐢

# ╔═╡ 3fa8d246-d380-11ea-2195-bd3862da65f0
#Divisão com b no numerador e a no denominador com o operador `\`
a \ 🐢

# ╔═╡ 5a3e856a-d380-11ea-25e5-f9bcb219d70e
#Potenciação com o operador `^`
a^🐢

# ╔═╡ 6b1f3104-d380-11ea-3f61-b3aa1408c4d9
#Divisão inteira de a por b com o operador `÷` (\div <Tab>)
div(a, 🐢)

# ╔═╡ 0ff9a65a-d381-11ea-2eb5-c3d6dc0e7cf1
#Divisão inteira de a por b com a função `div` (Mesmo que a célula acima)
a ÷ 🐢

# ╔═╡ c2a6e6f6-d380-11ea-2848-e765432972dd
#Resto da divisão inteira de a por b com o operador `%`
a % 🐢

# ╔═╡ 457a1f92-d49f-491a-b6c0-a3fcda46ace7
#Resto da divisão inteira de a por b com a função `rem` (Mesmo que a céular acima)
rem(a, 🐢)

# ╔═╡ d91246be-d381-11ea-22d3-bb8b8ce382c8
#Representação como racional de a / b
rationalize(a / 🐢)

# ╔═╡ 79b56c68-254d-4ff2-b9ee-407d8143bab4
# Representação como racional de a / l com operador `//`
a // l

# ╔═╡ 9fc3a96c-d380-11ea-2d22-c3b0f3800736
#Resíduo de b módula a com a função `mod`
mod(🐢, a)

# ╔═╡ d1257c48-d500-11ea-2bcc-8925c4e468f6
md"""

#### Operações lógicas

Vejamos agora algumas operações lógicas e de comparação.

Note que para os *valores* do *tipo* `Bool`, Julia usa as palavras-chave `true` e `false`. Estas palavras são reservadas pelo Julia.

* Os operadores lógicos são `||` (*disjunção*), `&&` (*conjunção*) e `!` (*negação*), em ordem crescente de hierarquia.


* Os operadores de comparação são `>`, `≥` (`\geq <Tab>`) ou `>=`, `<`, `≤` (`\leq <Tab>`) ou `<=`, e `==`. Como exceção, existe o operador `≡` (`\equiv <Tab>`) ou `===` que irá checar se dois *valores* são iguais e possuem o mesmo *tipo*. Retornam sempre um valor do tipo `Bool`.


* Existem dois operadores `&` e `|` que são *bitwise AND* e *bitwise OR*. Estes operadores funcionam **somente** entre pares de números inteiros expressos em dígitos binários.

Se uma sentença conter operações aritméticas, lógicas e de comparação, então a ordem de avaliação será: (1ᵃ) aritmética, (2ᵃ) comparação e então (3ᵃ) lógica.

A regra de resolução de conflitos de ordem de operações segue o posto acima, com preferência para avaliar primeiro o que está dentro de parênteses e, ocorrendo empate de hierarquia de operações, realizando primeiro a operação mais à esquerda e indo em ordem até a operação mais à direita.
"""

# ╔═╡ 982d5204-d3e4-11ea-3feb-6d17061562d5
#Checar uma igualdade com operador `==` 
#Neste caso, verifica se referem-se aos mesmos valores
a == 🐢

# ╔═╡ f2d99db2-d409-11ea-363d-1d58daadc79a
#Checar uma equivalência com operador `≡` (\equiv <Tab>) ou `===`
a ≡ 10

# ╔═╡ f898ebd8-d409-11ea-39a8-c5bf1392e99b
#Checar uma igualdade com `==`
a == 10

# ╔═╡ 73dca420-d3e4-11ea-2437-e5e894e94587
#Checar uma desigualdade com operador `≠` (\ne <Tab>)
a ≠ 🐢

# ╔═╡ def4e76b-6690-45a4-bf09-759b6496250f
#Checar uma desigualdade com operador `!=` (Mesmo que a célula acima)
a != 🐢

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
	
	### 4. Operações vetoriais
	
	O [construtor](https://docs.julialang.org/en/v1/base/arrays/#Core.Array) `Array()`, junto ao operador relacionado `[]`, criará um *vetor-coluna*. O delimitador padrão entre os elementos de vetores unidimensionais é a vírgula (`,`), no entanto, em vetores com mais dimensões, o delimitador para concatenar elementos na horizontal é o espaço em branco, enquanto que para concatenar elementos na vertical é o ponto-e-vírgula (`;`). Para criar vetores $n$-dimensionais, pode ser necessário usar o parâmetro de dimensão no comando `Array{<Tipo>, <n>}([<dados>], (<nᵒ de elementos d₁>, ..., <nᵒ de elementos dₙ>))`.
	
	O vetor é uma estrutura de dados *mutável* e *indexável* que pode ser fatiado pela notação de colchete: `x = [1, 2, 3, 4]; x[2:end] #[2,3,4]`. Note que `end` é um argumento de índice que indica o último elemento de um objeto. Além disso, é possível criar peridiciocidade no fatiamento por meio de um terceiro parâmetro: `x[<começo>:<passo>:<fim>]`. Também podemos usar o [operador](https://docs.julialang.org/en/v1/base/math/#Base.::) `:` para criar uma amplitude (*range*).
	
	Vetores também podem ser concatenados verticalmente com a [função](https://docs.julialang.org/en/v1/base/arrays/#Base.vcat) `vcat(<vetor1>, <vetor2>)` ou horizontalmente com a [função](https://docs.julialang.org/en/v1/base/arrays/#Base.hcat) `hcat(<vetor1>, <vetor2>)`. As funções exigem que os vetores tenham dimensões compatíveis ou retornarão erro.
	
	Caso os elementos sejam iteráveis ou uma amplitude (*range*), então o delimitador usado mudará o resultado final de maneira drástica.

	Espaçoem branco implicará que cada coluna será ocupada pelos elementos da amplitude, ou seja, a primeira coluna será dos termos da primeira amplitude, a segunda coluna será dos termos da segunda amplitude *etc*.;
	
	1. Vírgula(`,`) implicará que os próprios objetos de amplitude serão os elementos em um vetor-coluna;

	
	2. Ponto-e-vírgula(`;`) implicará que haverá uma única coluna com os elementos da amplitude, serão colocados um abaixo do outro seguindo a ordem.
	
	
	Uma mistura destes separadores pode ser usada para gerar algum efeito desejado. Por exemplo, `m6 = [1:3 4:6; 7:9 10:12]` gerará uma matriz com primeira coluna composta pelo vetor `[1, 2, 3, 7, 8, 9]` e a segunda coluna composta pelo vetor `[4, 5, 6, 10, 11, 12]`.

	Julia é uma linguagem *column-major*, ou seja, as estruturas de dados $n$-dimensionais são acessadas "verticalmente", seguindo as colunas. Assim, se `m1` é uma matriz $M$ 2 × 2, então `m1[1]` é o elemento $m_{1,1}$, `m1[2]` é o elemento $m_{2,1}$, `m1[3]` é o elemento $m_{1,2}$ e `m1[4]` é o elemento $m_{2,2}$ da matriz.
	
	Abaixo, na célula de código, vamos atribuir à variável `c` o arranjo 3 × 1 com elementos `[10.0; 10.0; 10.0]` do tipo `Array{Float64, 1}`. De maneira geral, em operações matemáticas, o Julia tratará arranjos como vetores. Para declarar explicitamente um vetor $n \times 1$, podemos usar o [construtor](https://docs.julialang.org/en/v1/base/arrays/#Base.Vector) `Vector()`. No caso de vetores bidimensionais $n \times n$, podemos fazer o mesmo para o *tipo* matriz por meio do [construtor](https://docs.julialang.org/en/v1/base/arrays/#Base.Matrix) `Matrix()`.
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

# ╔═╡ 43ad0664-d3a3-11ea-2166-879e9399ead3
#Formas de se criar o mesmo vetor 3 × 1
[3, 1, 1]

# ╔═╡ 4bc35814-d386-11ea-22e1-e1e19f5a34d8
#Formas de se criar o mesmo vetor 3 × 1
[3; 1 ;1]

# ╔═╡ 37601e7e-d393-11ea-3abe-ef3da3e63de2
#Note no entanto que esse é um vetor 1 × 3
[3 1 1]

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

# ╔═╡ 490a365c-d3ee-11ea-3ac7-65cdebf1ac8d
#Criando um arranjo de arranjos, em que cada arranjo é uma linha de um vetor-coluna
[[1, 2, 3], [1 2 3]]

# ╔═╡ 3cd0dd4a-d407-11ea-328a-1dd685dc6ea2
md"""
Vetores podem ter índices arbitrários ou que não representem o número e ordem dos seus elementos. Mais detalhes [aqui](https://docs.julialang.org/en/v1/devdocs/offset-arrays/#man-custom-indices-1).
"""

# ╔═╡ 5213eae6-d3e2-11ea-04bd-b1b48fe6f533
begin
	B = Matrix{Float64}(undef, 2, 2)
	
	md"""
	O pacote `LinearAlgebra` do Julia básico contém alguns construtores, operadores e funções especializados para Álgebra Linear, como, por exemplo, `I` para gerar uma matriz identidade de dimensão arbitrária. A documentação do pacote pode ser encontrada [aqui](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/) e é recomendado que qualquer pessoa com interesse em computação matemática se familiarize com este pacote. 
	
	Algumas funções especialmente importantes para a manipulação de vetores são:
	
	* A [função](https://docs.julialang.org/en/v1/base/arrays/#Base.ndims) `ndims()` retorna o número de dimensões de um vetor n-dimensional.
	
	
	* A [função](https://docs.julialang.org/en/v1/base/arrays/#Base.length-Tuple{AbstractArray}) `length()` retorna o número de elementos de um vetor.
	
	
	* A [função](https://docs.julialang.org/en/v1/base/arrays/#Base.size) `size()` retorna o comprimento de cada dimensão de um vetor.
	
	
	* A [função](https://docs.julialang.org/en/v1/base/arrays/#Base.zeros) `zeros()` retorna um vetor com todas as entradas nulas com a dimensão desejada.
	
	
	* A [função](https://docs.julialang.org/en/v1/base/arrays/#Base.ones) `ones()` retorna um vetor com todas as entradas iguais a 1 com a dimensão desejada.
	
	
	* A [função](https://docs.julialang.org/en/v1/base/arrays/#Base.reshape) `reshape(<objeto>, (<dimensões>))` permite alterar as dimensões de um vetor. Deste modo, se `v2 = [1 2 3]` é um vetor 1x3, então podemos transformá-lo em um vetor 3x1 com o comando `reshape(v2, (3, 1))`.
	
	
	* O [construtor](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/#LinearAlgebra.Diagonal) `Diagonal()` construirá uma matriz diagonal n × n se for passado um vetor n × 1 como argumento. 
	
	
	* A [função](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#LinearAlgebra.diag) `diag()` extrairá a diagonal de uma matriz, retornando-a como um vetor.
	
	
	É possível pré-alocar valores arbitrários em um vetor para que a estrutura tenha as dimensões correta por meio de `undef`. Por exemplo, podemos criar uma matriz 2 × 2 de elementos do tipo `Float64` com `Matrix{Float64}(undef, 2, 2)`. As [constantes](https://docs.julialang.org/en/v1/base/arrays/#Core.undef) `undef` irão utilizar valores que estejam disponíveis na memória ou marcados para serem removidos pelo *garbage collector* como *placeholders*.
	
	Além disso, há um [operador](https://docs.julialang.org/en/v1/manual/mathematical-operations/#man-dot-operators-1) *dot* (`.`) para funções escalares que aplicam a função a cada elemento de um vetor. Por exemplo: `cos.(A)` aplica a função `cos()` a todos os elementos da matriz $A$.
	"""
end

# ╔═╡ 3f99ff12-d3eb-11ea-11f3-5b5df7549571
#Verificando o valor da variável B
B

# ╔═╡ 4b7a5266-d3fd-11ea-3493-2d952e1fb5ba
md"""

Uma peculiaridade do Pluto.jl é que a atualização automática só ocorre quando alguma variável *imutável* é alterada. Logo, se `x = 2` e alteramos o programa para que `x = 3`, o Pluto.jl atualizará todas as células que contenham referência à variável x.

No entanto, os elementos do vetor são *mutáveis*, então se mudarmos algum elemento do vetor não teremos atualização automática. Isso só ocorrerá se mudarmos a própria variável do vetor, ou seja:

* Não irá ativar a reatividade: `x = [1, 2, 3] ; x[1] = 2 #[2, 2, 3]`.


* Irá ativar a reatividade: `x = [1, 2, 3], x = [2, 2, 3] #[2, 2, 3]`.

Lembrem-se, no entanto, que **não** é possível múltiplas atribuições de valor à mesma variável em células diferentes!
"""

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

# ╔═╡ 2f6d2ec4-6301-45cc-bde1-da719eb8fa58
correct(text=md"Excelente! Resposta certa.") = Markdown.MD(Markdown.Admonition("correct", "Parabéns!", [text]));

# ╔═╡ 4abe8449-5105-40c9-ad89-bb810698b5af
keep_working(text=md"A resposta ainda não está certa.") = Markdown.MD(Markdown.Admonition("danger", "Continue tentando!", [text]));

# ╔═╡ 80cf8be2-23a4-425d-9d52-2dc853519643
if l == a * b
	correct(md"""**Ótimo!** Obtemos o valor $l$ = $l.
	
	Agora volte para as células anteriores e mude o valor de **$a$ = $a** to **$a$ = $(a + 3)** e pressione `<Shift-Enter>`. Qual é o novo valor de $l$? Perceba que os valores foram atualizados em todas as células deste *notebook*. Isso se dá devido à **reatividade** do Pluto.jl!
	""")
else
	keep_working()
end

# ╔═╡ 8c96093c-d58f-4ea8-a0f5-e7f3d294c762
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Quase!", [text]));

# ╔═╡ 4fc0e643-e550-4f28-8fd0-2e67f1de7d7f
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Dica", [text]));

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
Plots = "~1.31.7"
PlutoUI = "~0.7.39"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.0"
manifest_format = "2.0"
project_hash = "a84bec35b7d9d29f58d209b70b156bceeef29a95"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "195c5505521008abea5aee4f96930717958eac6f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.4.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "80ca332f6dcb2508adba68f22f551adb2d00a624"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.3"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "1fd869cc3875b57347f7027521f561cf46d1fcd8"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.19.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "924cdca592bc16f14d2f7006754a621735280b74"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.1.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "5158c2b41018c5f7eb1470d558127ac274eca0c9"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.1"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.Extents]]
git-tree-sha1 = "5e1e4c53fa39afe63a7d356e30452249365fba99"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.1"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "ccd479984c7838684b3ac204b716c89955c76623"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "cf0a9940f250dc3cb6cc6c6821b4bf8a4286cf9c"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.66.2"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "2d908286d120c584abbe7621756c341707096ba4"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.66.2+0"

[[deps.GeoInterface]]
deps = ["Extents"]
git-tree-sha1 = "fb28b5dc239d0174d7297310ef7b84a11804dfab"
uuid = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"
version = "1.0.1"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "GeoInterface", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "a7a97895780dab1085a97769316aa348830dc991"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.3"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "f0956f8d42a92816d2bf062f8a6a6a0ad7f9b937"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.2.1"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "b3364212fb5d870f724876ffcd34dd8ec6d98918"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.7"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "1a43be956d433b5d0321197150c2f94e16c0aaa0"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.16"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "361c2b088575b07946508f135ac556751240091c"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.17"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "5d4d2d9904227b8bd66386c1138cf4d5ffa826bf"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "0.4.9"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "d9ab10da9de748859a7780338e1d6566993d1f25"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e60321e3f2616584ff98f0a4f18d98ae6f89bbb3"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.17+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "0044b23da09b5608b4ecacb4e5e6c6332f833a7e"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.2"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "9888e59493658e476d3073f1ce24348bdc086660"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "a19652399f43938413340b2068e11e55caa46b65"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.31.7"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "8d1f54886b9037091edf146b517989fc4a09efec"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.39"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "e7eac76a958f8664f2718508435d058168c7953d"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.3"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "22c5201127d7b243b9ee1de3b43c408879dff60f"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.3.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "85bc4b051546db130aeb1e8a696f1da6d4497200"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.5"

[[deps.StaticArraysCore]]
git-tree-sha1 = "5b413a57dd3cea38497d745ce088ac8592fbb5be"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.1.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArraysCore", "Tables"]
git-tree-sha1 = "8c6ac65ec9ab781af05b08ff305ddc727c25f680"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.12"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "4ad90ab2bbfdddcae329cba59dab4a8cdfac3832"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.7"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "e59ecc5a41b000fa94423a578d29290c7266fc10"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─f23b2bd5-8d24-4b91-b6ae-937fca943fbd
# ╟─7548fe76-b328-11ea-1dff-b16fc38e0cc5
# ╠═9e6b5a0e-d454-11ea-3cd8-69b687166340
# ╟─11bce208-d445-11ea-277d-d1f081a3f39f
# ╟─5e466b68-163d-4942-96ce-bfd6077788ce
# ╠═5e55de14-d452-11ea-20bd-114c97ba4df2
# ╠═3a4d9dee-d453-11ea-1024-9d8b156212c7
# ╠═3c66adf2-d456-11ea-2503-89147b7afded
# ╠═c34df1f0-d455-11ea-09e3-c9982355f070
# ╟─78495249-e827-41b4-b130-c9d2bac743e6
# ╠═4589e708-d453-11ea-15f4-7f4efb68b159
# ╠═7d0cf292-d453-11ea-34d8-4bd8ff8b925c
# ╠═cc640950-d455-11ea-1700-79b264b0bb2c
# ╠═499979dc-d456-11ea-1c5c-27988e76b40a
# ╟─be28b162-90eb-43c8-baa2-6bd333b5a1c8
# ╠═0a5f13f0-d454-11ea-2fb9-f3b15278c9ee
# ╠═18ca704c-d454-11ea-1900-bf83468082d0
# ╠═8a721040-d456-11ea-3625-63fcaaf109d2
# ╠═c5c73409-2d40-4e97-8b41-7226076a300e
# ╠═244d9106-d454-11ea-2672-6d3da0d2fff6
# ╟─b103a520-5719-4da3-b25f-e2b538afca29
# ╠═ab8b9182-d453-11ea-1ddb-89717ea927fb
# ╠═cd2754ca-d453-11ea-0c1e-0507fd4a323c
# ╠═98e5f79a-d456-11ea-036f-6148262b7d68
# ╟─ba514512-d378-11ea-2baa-9d3ed72cec53
# ╠═fd08e20a-88c2-4723-abfc-0f8192cac8f6
# ╠═f81a7bb1-ff2e-4a55-8d04-f4cb651abb38
# ╟─1117fc83-4c8b-4a01-b609-4af17cf7d36a
# ╠═867971b1-765a-4315-af7a-f7b3d296999b
# ╟─80cf8be2-23a4-425d-9d52-2dc853519643
# ╟─4e8cda56-d37f-11ea-2044-f97c6be953de
# ╠═3edc3ff6-d461-11ea-0bbf-8788f190f750
# ╠═4b2e3e5e-d465-11ea-37b0-87f8a3d719b6
# ╠═4f8ce150-d466-11ea-3d3b-612a86a20dd5
# ╟─7283abe8-d467-11ea-3097-3b063f8a3ca3
# ╟─71e90f4a-d467-11ea-14ea-8ddad3ed52b3
# ╠═94563de6-d381-11ea-08f4-fbfeaf4cc4d5
# ╟─8525f9c9-2d02-42c5-895b-b082b97dcfb4
# ╠═25960f18-d380-11ea-1a4b-f9ba52963806
# ╠═2c61bc66-d380-11ea-1a6e-5dc74f8e39c6
# ╠═328fa512-d380-11ea-0509-edff01e88423
# ╠═36e87f44-d380-11ea-0632-6fafa86b2ba2
# ╠═3fa8d246-d380-11ea-2195-bd3862da65f0
# ╠═5a3e856a-d380-11ea-25e5-f9bcb219d70e
# ╠═6b1f3104-d380-11ea-3f61-b3aa1408c4d9
# ╠═0ff9a65a-d381-11ea-2eb5-c3d6dc0e7cf1
# ╠═c2a6e6f6-d380-11ea-2848-e765432972dd
# ╠═457a1f92-d49f-491a-b6c0-a3fcda46ace7
# ╠═d91246be-d381-11ea-22d3-bb8b8ce382c8
# ╠═79b56c68-254d-4ff2-b9ee-407d8143bab4
# ╠═9fc3a96c-d380-11ea-2d22-c3b0f3800736
# ╟─d1257c48-d500-11ea-2bcc-8925c4e468f6
# ╠═982d5204-d3e4-11ea-3feb-6d17061562d5
# ╠═f2d99db2-d409-11ea-363d-1d58daadc79a
# ╠═f898ebd8-d409-11ea-39a8-c5bf1392e99b
# ╠═73dca420-d3e4-11ea-2437-e5e894e94587
# ╠═def4e76b-6690-45a4-bf09-759b6496250f
# ╠═3c9b3894-d382-11ea-32cc-1f075f8fff54
# ╠═0af09224-d389-11ea-115e-4ba278ee876a
# ╠═573f4b9c-d38a-11ea-137e-cfbf238c3d14
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
# ╠═4b7a5266-d3fd-11ea-3493-2d952e1fb5ba
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
# ╠═2f6d2ec4-6301-45cc-bde1-da719eb8fa58
# ╠═4abe8449-5105-40c9-ad89-bb810698b5af
# ╠═8c96093c-d58f-4ea8-a0f5-e7f3d294c762
# ╠═4fc0e643-e550-4f28-8fd0-2e67f1de7d7f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
