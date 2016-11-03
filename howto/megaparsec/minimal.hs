-- based on (and simpler than) the tutorial at https://mrkkrp.github.io/megaparsec/tutorials/parsing-simple-imperative-language.html

    module Experim where

    import Control.Monad (void)
    import Text.Megaparsec
    import Text.Megaparsec.Expr
    import Text.Megaparsec.String -- input stream is of type ‘String’
    import qualified Text.Megaparsec.Lexer as L

  -- tiny parsers
    sc :: Parser () -- space consumer
    sc = L.space (void spaceChar) lineCmnt blockCmnt
      where lineCmnt  = L.skipLineComment "//"
            blockCmnt = L.skipBlockComment "/*" "*/"

    lexeme :: Parser a -> Parser a
    lexeme = L.lexeme sc

    symbol :: String -> Parser String
    symbol = L.symbol sc

    integer :: Parser Integer
    integer = lexeme L.integer

    parseInts :: Parser [Int]
    parseInts = sc *> (many $ fromIntegral <$> integer)

    parens :: Parser a -> Parser a
    parens = between (symbol "(") (symbol ")")

    identifier :: Parser String
    identifier = lexeme $ (:) <$> letterChar <*> many alphaNumChar

  -- expressions, operators and recursion
    data AExpr = Var String | Pair AExpr AExpr deriving (Show)

    aExpr :: Parser AExpr
    aExpr = makeExprParser aTerm aOperators

    aTerm :: Parser AExpr
    aTerm = parens aExpr   <|>   Var <$> identifier

    aOperators :: [[Operator Parser AExpr]]
    aOperators =
      [ [ InfixN $ symbol "#1" *> pure (Pair) ]
      , [ InfixN $ symbol "#2" *> pure (Pair) ]
      ]
      -- PITFALL: Previously, these symbols were # and ##, and the # was listed first. In that case, "a ## b" would not parse, because it would read the first # and think it was done. (See Haskell Cafe thread "Why is Megaparsec treating these two operators differently?", from October 23 2016, and|or the file "experim.buggy.hs".)

  -- it works!
    test = map (parseMaybe aExpr) exprsToParse
    exprsToParse = [ "a #1 b"
                   , "a #2 b"
                   , "a #1 b #2 c #1 d"
                   , "(a #1 b) #1 (c #1 d)"
                   ]