{-# LANGUAGE ViewPatterns #-}

module Dwt.Tplt (
  _splitStringForTpltMB
  , pTplt
  )where

import Dwt.Types
import Dwt.Util (fr)

import Text.Megaparsec
import Dwt.ParseUtils (Parser, anyWord, lexeme, parens, phrase, word, sc)
import Text.Megaparsec.Expr (makeExprParser, Operator(..))
import Text.Megaparsec.Char (satisfy, string, char)


type PTplt = [PTpltUnit]
data PTpltUnit = Blank | Phrase String deriving Show

_splitStringForTpltMB :: String -> [Maybe String]
_splitStringForTpltMB = fr . parse pTplt ""

pTplt :: Parser [Maybe String]
pTplt = toMaybeStrings . dropNonExtremeBlanks
        <$> many (pBlank <|> pPhrase)
  where pBlank, pPhrase :: Parser PTpltUnit
        pBlank = const Blank <$> lexeme (char '_')
        pPhrase = Phrase <$> phrase

dropNonExtremeBlanks :: PTplt -> PTplt
dropNonExtremeBlanks us = map snd $ filter f zs
  where zs = zip [1..] us
        f (_, Phrase _) = True
        f (1,Blank) = True
        f ((== length us) -> True, Blank) = True
        f (_,Blank) = False

toMaybeStrings :: PTplt -> [Maybe String]
toMaybeStrings = map f where f Blank = Nothing
                             f (Phrase p) = Just p
