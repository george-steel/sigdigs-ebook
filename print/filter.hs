#!/usr/bin/env runhaskell
import Text.Pandoc.JSON
import Text.Pandoc.Walk

citeright :: Inline -> Inline
citeright (RawInline (Format "html") "<cite>") = RawInline (Format "tex") "\\sourceatright{"
citeright (RawInline (Format "html") "</cite>") = RawInline (Format "tex") "}"
citeright x = x

bfilter :: Block -> [Block]
bfilter (Div (_,["postepi"],_) xs) = [RawBlock (Format "latex") "\\begin{postepi}"] ++ walk citeright xs ++ [RawBlock (Format "latex") "\\end{postepi}"]
bfilter x = [x]

main :: IO ()
main = toJSONFilter bfilter