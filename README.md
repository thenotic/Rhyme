
Running 
-----------------

To Run, you need a few lines of lyrics.  An Example is shown here.

```ruby

a = Rhyme.new
a.lyrics = "The only nigga in the hood you can come see for either weed or coca
Nark's wanna see me and my team in a chair
They heard about the kid with the high beams in his ear
D E A been lookin' for proof since nine three
When I came through in the Benz with the roof behind me
Tell them jake's, throw on bullet proof's and find me
You need extinguishers to go in the booth behind me
Who the fuck wanna beef?
My Fendi knits be 3X, so you can't see whats tucked underneath
And I might not even drop
Just take my advance and make a small town in Cleveland pop
Vivrant Thing on my hip, that will make you Breathe and Stop
Rock ya chain in ya shirt, you roll with your sleeves on top
You niggas know where my heat stay at
I leave niggas MIA and I ain't talkin' where the Heat play at, c'mon" #Fabolous - Keepin It Gangsta
a.find_rhymes

a.one_syllable_rhymes
#[["only -- coca", "OW1 N L", "OW1 K"], ["come -- wanna", "AH1 M", "AA1 N"], ["see -- weed", "IY1 |", "IY1 D"], ["see -- team", "IY1 |", "IY1 M"], ["see -- beams", "IY1 |", "IY1 M Z"], ["either -- see", "IY1 DH |", "IY1 |"], ["either -- team", "IY1 DH |", "IY1 M"], ["either -- beams", "IY1 DH |", "IY1 M Z"], ["weed -- see", "IY1 D", "IY1 |"], ["weed -- kid", "IY1 D", "IH1 D"], ["weed -- beams", "IY1 D", "IY1 M Z"], ["weed -- dea", "IY1 D", "IY1 |"], ["narks -- wanna", "AA1 R K S", "AA1 N"], ["see -- team", "IY1 |", "IY1 M"], ["see -- beams", "IY1 |", "IY1 M Z"], ["see -- dea", "IY1 |", "IY1 |"], ["team -- beams", "IY1 M", "IY1 M Z"], ["chair -- ear", "EH1 R", "IH1 R"], ["high -- behind", "AY1 |", "AY1 N D"], ["beams -- dea", "IY1 M Z", "IY1 |"], ["ear -- been", "IH1 R", "IH1 N"], ["been -- since", "IH1 N", "IH1 N S"], ["lookin -- bullet", "UH1 K", "UH1 L"], ["proof -- through", "UW1 F", "UW1 |"], ["proof -- roof", "UW1 F", "UW1 F"], ["proof -- proofs", "UW1 F", "UW1 F S"], ["since -- extinguishers", "IH1 N S", "IH1 NG G W"], ["came -- them", "EY1 M", "EH2 M"], ["came -- jakes", "EY1 M", "EY1 K S"], ["through -- roof", "UW1 |", "UW1 F"], ["through -- proofs", "UW1 |", "UW1 F S"], ["benz -- them", "EH1 N Z", "EH2 M"], ["roof -- proofs", "UW1 F", "UW1 F S"], ["roof -- booth", "UW1 F", "UW1 TH |"], ["behind -- find", "AY1 N D", "AY1 N D"], ["proofs -- booth", "UW1 F S", "UW1 TH |"]...]

a.two_syllable_rhymes
#[["see for", "weed or", 10, 13, 1, 1], ["see me", "ear d", 18, 37, 1, 1], ["see me", "d e", 18, 38, 1, 1], ["team in", "beams in", 22, 34, 1, 1], ["team in", "three when", 22, 47, 1, 1], ["high beams", "nine three", 33, 46, 1, 1], ["high beams", "behind me", 33, 58, 1, 1], ["beams in", "three when", 34, 47, 1, 1], ["proof since", "through in", 44, 51, 1, 1], ["proof since", "roof behind", 44, 57, 1, 1], ["nine three", "behind me", 46, 58, 1, 1], ["nine three", "find me", 46, 68, 1, 1], ["through in", "roof behind", 51, 57, 1, 1], ["roof behind", "booth behind", 57, 77, 1, 1], ["behind me", "find me", 58, 68, 1, 1], ["find me", "behind me", 68, 78, 1, 1], ["fuck wanna", "tucked underneath", 82, 95, 1, 1], ["fuck wanna", "drop just", 82, 102, 1, 1], ["wanna", "tucked underneath", 83, 95, 1, 1], ["underneath and", "even", 96, 101, 1, 1], ["underneath and", "cleveland", 96, 113, 1, 1], ["even", "cleveland", 101, 113, 1, 1], ["even", "breathe and", 101, 124, 1, 1], ["drop just", "rock ya", 102, 127, 1, 1], ["cleveland", "breathe and", 113, 124, 1, 1], ["breathe and", "mia", 124, 151, 1, 1], ["heat stay", "heat play", 145, 158, 1, 1], ["stay at", "play at", 146, 159, 1, 1]]

a.three_syllable_rhymes
#[["see me and", "d e a", 18, 38, 1, 1], ["high beams in", "nine three when", 33, 46, 1, 1], ["proof since nine", "roof behind", 44, 57, 1, 1], ["even drop", "cleveland pop", 101, 113, 1, 1], ["even drop", "breathe and stop", 101, 124, 1, 1], ["drop just take", "rock ya chain", 102, 127, 1, 1], ["cleveland pop", "breathe and stop", 113, 124, 1, 1]]

```
