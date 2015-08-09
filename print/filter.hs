#!/usr/bin/env runhaskell
import Text.Pandoc.JSON
import Text.Pandoc.Walk

citeright :: Inline -> Inline
citeright (RawInline (Format "html") "<cite>") = RawInline (Format "latex") "\\sourceatright{"
citeright (RawInline (Format "html") "</cite>") = RawInline (Format "latex") "}"
citeright x = x

ifilter :: Inline -> Inline
ifilter (Span hs@(_,_,[("lang","el")]) xs) = Span hs ([RawInline (Format "latex") "\\textgreek{"] ++ xs ++ [RawInline (Format "latex") "}"])
ifilter x = x

bfilter :: Block -> Block
bfilter (Div hs@(_,["postepi"],_) xs) = Div hs ([RawBlock (Format "latex") "\\begin{postepi}"] ++ walk citeright xs ++ [RawBlock (Format "latex") "\\end{postepi}"])
bfilter x = x

myfilter :: Pandoc -> Pandoc
myfilter = walk bfilter . walk ifilter

main :: IO ()
main = toJSONFilter myfilter