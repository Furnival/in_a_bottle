### A Pluto.jl notebook ###
# v0.19.38

using Markdown
using InteractiveUtils

# ╔═╡ 7397dab7-ae5b-4994-9129-6c05e14c7e37
begin
	using HTTP
	using JSON
end

# ╔═╡ 84a108b0-4900-11ef-21cd-1d92dd9840a0
md"""
# Disaster in a bottle  
*a series of experiments on using AI for collaboration in solo wargames*  
"""

# ╔═╡ 53b2c048-197c-4d55-b250-cb901a2297db
md"""
## Todo
Thinking about interface:\

- would like a [Windrift](https://windrift.app) style like Lisa Daly's [Stone Harbor](https://stoneharborgame.com) 
- ease and flow and lack of distraction, comfort of book-like interface. Not 100% on this but worth a try. 
- Thinking that local server and [htmx](https://htmx.org) is a simple way to go. Mock up a trial with static generated content with [Oxygen.jl](https://github.com/OxygenFramework/Oxygen.jl)

"""

# ╔═╡ acb6542c-21b3-4137-92e0-ec1ca95162a3
md"""
```
[x] - get local server running with oxygen   
[x] - add htmx source file to server and load and test with simple markup  
[ ] - improve test htmx to make it Windrift-like
[ ] - make querystrings -> responses with ollama at commandline
[ ] - mock up trial interface and ask testers to use it.
[ ] - parse ollama replies for get structured responses
[ ] - template content replies in mustashe
[ ] - logging and 'story-so-far'
[ ] - if LLM generates markdown, how to convert?
```
- NGINX for proxy for https?\
- [Use edit text in place](https://htmx.org/examples/click-to-edit/): for entering arbitrary text - how to pick up changes on server? is a post.\
- 
"""

# ╔═╡ 85dc48af-0a95-4a68-85c4-7687c0a276c9
md"""
### Server
"""

# ╔═╡ b6ad416e-8e84-4ac1-9b5c-602b569fa3b5
md"""
- problem: css and centering quote text and button. 
"""

# ╔═╡ 6bc76bcb-5893-4a88-ae69-352d1b7a08a2
md"""
[localhost](http://127.0.0.1:8080) -- testing Oxygen server
- [hello_world in text](http://127.0.0.1:8080/greet/)
- [hello_world in html](http://127.0.0.1:8080/html/)
- [add by paths](http://127.0.0.1:8080/add/3/4/)
- [return GET queries](http://127.0.0.1:8080/query?name1=value1&name2=value2)
- [return GET queries 2](http://127.0.0.1:8080/query2?a=5&message=aString)
- [first page](http://127.0.0.1:8080/story)

"""

# ╔═╡ e71a80e1-502d-4299-b054-a204f5414500


# ╔═╡ d8c4877c-6962-4565-99de-9cfe906b0268
md"""
`<script src="utils/htmx.min.js"></script>` - not working - stuff cached?

`<script src="https://unpkg.com/htmx.org@2.0.1"></script>`

`html {scroll-behavior: smooth;}`
"""

# ╔═╡ 91c90352-e0f5-4a7f-b2ab-0351f3449cf9
mycommand = `echo hello`

# ╔═╡ fd85b6bf-dba3-43f8-a53d-0a4fa8288408
run(mycommand);

# ╔═╡ bcdda97e-c789-4d41-b298-2a237669ed7b
readchomp(`echo hello`)

# ╔═╡ d276fe59-2635-4de2-b7b4-f7eb503faeb2
ollama_wg = `ollama run llama3.1 "generate a matrix wargame scenario about election cyber security in markdown format with sections for Background, Objectives, Starting Situation, Players, and Potential Actions"`

# ╔═╡ 8e08aec6-a9aa-43de-a09e-4693648dbba1
ollamatest2 = `ollama run llama3.1 "why is the sky blue"`

# ╔═╡ 6119051d-e155-4a44-8424-46e5679d1d72
matrix = String(readchomp(ollama_wg))

# ╔═╡ e9893ab0-6649-4507-9fcc-3025b51963a1
open("/Users/furnival/Documents/GitHub/in_a_bottle/matrix.md", "w") do f
    write(f, matrix)
end

# ╔═╡ c0666883-ae5c-45ae-89d4-1c4e376e968a
run(`open ./matrix.md`)

# ╔═╡ bfc86f31-f176-455b-b49f-522980cf21b8
matrix

# ╔═╡ bf2b5f84-5387-4eb9-bc56-bfbd8ba71cf0
m_title = match(r"\*\*([^\*]+)\*\*", matrix)

# ╔═╡ 96500d59-afd5-483c-8acd-554e6ad871dd
m_title[1]
# if isnothing(m_title[1]) # or just not match? isnothing(m_title)
#   print out something?
# end
# checkfornothing(m_title) return an alert for now? OK, NOK?

# ╔═╡ d7da5324-9f75-4228-9b59-12c94d4a87a2
wgame = Dict("title" => m_title[1])

# ╔═╡ c9ceaa6a-c73c-4504-96ce-ab389e0a5a26
#  wgame["title"] =  m_title[1]

# ╔═╡ c16bc75c-2db1-486f-92c7-91bea700676d
m_background = match(r"###\s+\**Background\**\s*\n+[=\-]*\n*([^#]+)", matrix)

# ╔═╡ 7f7e20a8-d409-406f-9179-e71bee167cf7
wgame["background"] = m_background[1]
# need to detect empty value

# ╔═╡ e786eea2-6da6-47d9-8f82-4ca285f389a0
m_objectives = match(r"###\s+\**Objectives\**\s*\n+[\-=]*\n*([^#]+)", matrix)

# ╔═╡ 7b32de9b-b46e-45d9-9502-ed71067df8a2
wgame["objectives"] = m_objectives[1]

# ╔═╡ 0db0dec6-4d5f-4ce7-a6ea-d5a7851cc3e2
m_situation = match(r"###\s+\**Starting Situation\**\s*\n+[\-=]*\n*([^#]+)", matrix)

# ╔═╡ 868f3a4c-ac15-425e-9fc1-d3aa4ce381a7
wgame["situation"] = m_situation[1]

# ╔═╡ ca167e10-94a0-412d-ae06-c203d38140a4
m_players = match(r"###\s+\**Players\**\s*\n+[\-=]*\n*([^#]+)", matrix)

# ╔═╡ e07775b3-0832-4433-8706-b4b05eeab3a4
m_players[1]
# need to parse and count players

# ╔═╡ b37cc3f7-e882-4e82-a35c-958c7756e774
m_actions = match(r"###\s+\**Potential Actions\**\s*\n+[\-=]*\n*([^#]+)", matrix)

# ╔═╡ 7c71719b-f7e7-4dda-ab02-c1b790e47543
m_actions[1]

# ╔═╡ 336ce6d6-a0c0-4dae-8e0d-a9650e6d5962
md"------------"

# ╔═╡ d03ee3bd-783f-42f4-9ff8-5a94949244d0
begin
	wargame = Dict( "name" => "Election Cyber Security War Game Scenario",
	"story so far" => "Blueteam is not alert and does not know Redteam is attacking. ")
 
	redteam = Dict{String, String}("name" => "Russian state sponsored hackers", "character" => "Aggressive but subtle", "goal" => "Not to change election results but to give the American public the impression that the election results cannot be trusted", "strategy" => "To plant evidence of corrupt dealings with local election officials in many states" )
	
	redteam["example1"] = "The redteam phishes the top Democratic leadership and gains root access to the chairman's email and desktop computer. This is successful because the leadership has not taken the time to complete anti-phishing training that is available."
	
	redteam["example2"] = "The redteam inserts trojans in a game that the teenaged son of a top Democratic party worker uses on his mother's computer at work and thus gains full root access to a top Democratic worker's computer. This succeeds because workers are encouraged to bring children to work but the workers are busy and there is no childcare." 
	
	
end

# ╔═╡ e39d5946-92e6-46ed-ac37-1b891e6a9331
prompt_string = """
Given that you are playing a wargame called $(wargame["name"]) and you are $(redteam["name"]) with the general character of $(redteam["character"]) and the goal of $(redteam["goal"]) and a summary of the game so far is $(wargame["story so far"]), and your general strategy is $(redteam["strategy"]). Example moves might be "$(redteam["example1"]), "$(redteam["example2"]). What would your next move be? Answer in two sentences describing the move and two describing why is it likely to succeed.
"""

# ╔═╡ d6721217-665d-4232-88da-8655426d81c1


# ╔═╡ b1e27c97-8048-4548-a80d-317d210ce6b1
begin
	url = "http://localhost:11434/api/generate"
	
	function update_prompt(question)
	    data = Dict() # declare empty to support Any type.
	    data["model"] = "mistral"
	    data["prompt"]= question
	    data["stream"]= false  # turning off streaming response.
	    data["temperature"] = 0.0
	    return JSON.json(data)
	end
	
	data = update_prompt(prompt_string)
	res  = HTTP.request("POST",url,[("Content-type","application/json")],data)
	if res.status == 200
	    body = JSON.parse(String(res.body))
	    #println(body["response"])
		body["response"]
	end
end

# ╔═╡ d1af6480-afaf-4415-b389-35de2375ea35
open("/Users/furnival/Documents/GitHub/in_a_bottle/matrix.md", "a") do filehandle
       write(filehandle, "\n" * body["response"])

end  

# ╔═╡ 9393b849-518f-43cc-9b72-6bd09c91f5ba
md"""
1. "Redteam creates a fake news article implicating several local election officials in various corrupt activities, manipulating the content to appear on popular news websites that are frequently visited by the American public." This move is likely to succeed because of the widespread trust in online media and the lack of vigilance among internet users regarding the authenticity of news articles.

2. "Redteam uses advanced social engineering tactics to disseminate the fake news article through a network of bots, trolls, and compromised accounts on various social media platforms." This move is likely to succeed due to the vast reach of social media networks and the susceptibility of users to believe information shared by their peers or perceived authority figures.

------------

1. "Redteam disguises themselves as a cybersecurity firm offering a free security audit for the Democratic Party, gaining access to their network infrastructure. This is likely to succeed because, despite previous breaches, the party may view this offer as an opportunity to improve their security measures."

2. "Redteam creates and disseminates leaked emails among various political groups and social media platforms, hinting at the existence of incriminating evidence against local election officials. This is likely to succeed because it will sow distrust among the public about the integrity of the election process, aligning with our goal."

------------
Next Move: "Redteam creates a sophisticated forgery of an email conversation between the top Democratic leadership and local election officials, discussing secret deals in exchange for vote manipulation. This email is then planted in the compromised chairman's email account."

   Reason for Success: 1) The timing of the forgery's release could coincide with a crucial election period, maximizing its impact on public perception. 2) The content of the forgery is plausibly deniable, making it difficult for Blueteam to definitively prove its authenticity or lack thereof, thereby sowing doubt in the integrity of the election process.

*CHANGED TEMPTRATURE TO: 0.9*\
 Next Move: "The redteam disguises the trojan as a harmless software update for the voting systems used in several key battleground states, thereby gaining unauthorized access to the systems."

   Reason for Success: 1) Voting system providers may neglect regular security updates or rely on third-party vendors, making them vulnerable to such disguised attacks. 2) The lack of transparency and standardization in voting systems across various states could lead to different levels of vigilance and preparedness, creating an uneven defense landscape that the redteam can exploit.

"""

# ╔═╡ 2c2fc88a-9204-4904-b435-91be3c1f846f
md"""
#### Maybe
```
[x] - build a red query template with story_so_far and multishot moves
[ ] - ask minstral to make a move for red (suggest 4 proposed moves?)
[ ] - save to story_so_far, ask ollama for summary now? and write to file
[ ] - ask llama3.1 to make argument from blue against (propose 4 counters?)
[ ] - I judge arguments and roll dice. Switch to blue. write to story_so_far
```
"""

# ╔═╡ 223feab8-e513-46b5-8522-986887de1f5c
md"""
--------
## Utilities
---------
"""

# ╔═╡ 41bc4d06-a371-4178-a93d-b06ed471a926
md"""
### parsing utilites
- `parse_scenario() i.e. -> current_scenario{"red_goals"}`
- `current_scenario = Dict{String, String}("red_goals" => red, "blue_goals" => blue, "red_name" => "red", "blue_name" => "blue")`
- test for empty values or non matching - need to harden regex to accept variations
- player Goals = Objectives so change back?
- need player characters (aggressive, calm, etc.)
"""

# ╔═╡ c819351f-c2c2-4007-b8ae-ee2d4a1be776
md"""
----------------------
# Notes 

> ollama run llama3 "Summarize this file: $(cat README.md)"

```
curl http://localhost:11434/api/generate -d '{
  "model": "llama3",
  "prompt":"Why is the sky blue?"
}'
```
"""

# ╔═╡ 8c0eb3be-adbb-4d28-ade9-139e091eac2f
md"""
```
Given that you are playing a wargame called $wargame_name and you are $redteam["name"] with the general character of $redteam["character"] and the goal of $redteam["goal"] and a summary of the game so far is $story_so_far, and your general strategy is $redteam["strategy"]. Example moves might be $redteam["example"][1], $redteam["example"][2]. What would your next move be? Answer in two sentences describing the move and two describing why is it likely to succeed.
```
"""

# ╔═╡ 34a3c50c-8d9a-4b2e-ab31-b50a1012aa36
md"""
```
open("/tmp/t.txt", "w") do f
    write(f, "A, B, C, D\n")
end
```
"""

# ╔═╡ d3eb63a4-5a93-4293-8a97-f7045f0b8427
md"""
[commandline](https://docs.julialang.org/en/v1/manual/running-external-programs/) - external program notes  \
[ollama api docs](https://github.com/ollama/ollama/blob/main/docs/api.md)
"""

# ╔═╡ 6d71ba9a-4f91-42ad-8ea6-60f0be9d3307
md"""
scenario generation prompt:

	generate a matrix wargame scenario about election cyber security in markdown format with sections for Background, Objectives, Starting Situation, Players, and Potential Actions 
"""

# ╔═╡ b21660b7-e4d5-4d19-b0f3-bdc5100d9f36
md"""
- scenario generation from API returning in markdown (v2 = json?)
- parse scenario into:
	1. Scenario name
	2. Background
	3. Objectives
	4. Starting Situation
	5. Potential Actions
	6. Players (number and names)
	? -> 7. Long term strategy for each player
#### maybe

	- Sample arguments
	- Ajudication guidelines
	- How many rounds
	- Potential strategies/ resources

#### combine with:
	- "story so far"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HTTP = "cd3eb016-35fb-5094-929b-558a96fad6f3"
JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"

[compat]
HTTP = "~1.10.8"
JSON = "~0.21.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.2"
manifest_format = "2.0"
project_hash = "b808d08ee6d7a527c25869ae717647b2b8f90123"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "b8fe8546d52ca154ac556809e10c75e6e7430ac8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.5"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "ea32b83ca4fefa1768dc84e504cc0a94fb1ab8d1"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.2"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "d1d712be3164d61d1fb98e7ce9bcbc6cc06b45ed"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.8"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a028ee3cb5641cccc4c24e90c36b0a4f7707bdf5"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.14+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
git-tree-sha1 = "96612ac5365777520c3c5396314c8cf7408f436a"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.1"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"
"""

# ╔═╡ Cell order:
# ╟─84a108b0-4900-11ef-21cd-1d92dd9840a0
# ╠═7397dab7-ae5b-4994-9129-6c05e14c7e37
# ╟─53b2c048-197c-4d55-b250-cb901a2297db
# ╟─acb6542c-21b3-4137-92e0-ec1ca95162a3
# ╟─85dc48af-0a95-4a68-85c4-7687c0a276c9
# ╠═b6ad416e-8e84-4ac1-9b5c-602b569fa3b5
# ╠═6bc76bcb-5893-4a88-ae69-352d1b7a08a2
# ╠═e71a80e1-502d-4299-b054-a204f5414500
# ╠═d8c4877c-6962-4565-99de-9cfe906b0268
# ╠═91c90352-e0f5-4a7f-b2ab-0351f3449cf9
# ╠═fd85b6bf-dba3-43f8-a53d-0a4fa8288408
# ╠═bcdda97e-c789-4d41-b298-2a237669ed7b
# ╠═d276fe59-2635-4de2-b7b4-f7eb503faeb2
# ╠═8e08aec6-a9aa-43de-a09e-4693648dbba1
# ╠═6119051d-e155-4a44-8424-46e5679d1d72
# ╠═e9893ab0-6649-4507-9fcc-3025b51963a1
# ╠═c0666883-ae5c-45ae-89d4-1c4e376e968a
# ╠═bfc86f31-f176-455b-b49f-522980cf21b8
# ╠═bf2b5f84-5387-4eb9-bc56-bfbd8ba71cf0
# ╠═96500d59-afd5-483c-8acd-554e6ad871dd
# ╠═d7da5324-9f75-4228-9b59-12c94d4a87a2
# ╠═c9ceaa6a-c73c-4504-96ce-ab389e0a5a26
# ╠═c16bc75c-2db1-486f-92c7-91bea700676d
# ╠═7f7e20a8-d409-406f-9179-e71bee167cf7
# ╠═e786eea2-6da6-47d9-8f82-4ca285f389a0
# ╠═7b32de9b-b46e-45d9-9502-ed71067df8a2
# ╠═0db0dec6-4d5f-4ce7-a6ea-d5a7851cc3e2
# ╠═868f3a4c-ac15-425e-9fc1-d3aa4ce381a7
# ╠═ca167e10-94a0-412d-ae06-c203d38140a4
# ╠═e07775b3-0832-4433-8706-b4b05eeab3a4
# ╠═b37cc3f7-e882-4e82-a35c-958c7756e774
# ╠═7c71719b-f7e7-4dda-ab02-c1b790e47543
# ╟─336ce6d6-a0c0-4dae-8e0d-a9650e6d5962
# ╟─d03ee3bd-783f-42f4-9ff8-5a94949244d0
# ╠═e39d5946-92e6-46ed-ac37-1b891e6a9331
# ╠═d6721217-665d-4232-88da-8655426d81c1
# ╠═b1e27c97-8048-4548-a80d-317d210ce6b1
# ╠═d1af6480-afaf-4415-b389-35de2375ea35
# ╟─9393b849-518f-43cc-9b72-6bd09c91f5ba
# ╟─2c2fc88a-9204-4904-b435-91be3c1f846f
# ╟─223feab8-e513-46b5-8522-986887de1f5c
# ╠═41bc4d06-a371-4178-a93d-b06ed471a926
# ╟─c819351f-c2c2-4007-b8ae-ee2d4a1be776
# ╟─8c0eb3be-adbb-4d28-ade9-139e091eac2f
# ╟─34a3c50c-8d9a-4b2e-ab31-b50a1012aa36
# ╟─d3eb63a4-5a93-4293-8a97-f7045f0b8427
# ╠═6d71ba9a-4f91-42ad-8ea6-60f0be9d3307
# ╠═b21660b7-e4d5-4d19-b0f3-bdc5100d9f36
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
