# ChunkSpec

A lightweight, human-readable Domain-Specific Language (DSL) designed to describe grammar chunks in human languages.

## System Requirements

* Perl 5.36+

## Rationale

When implementing rule-based parsers for human languages, JSON is often preferred for defining grammar rules. However, dense JSON files can resemble verbose XML structures, making them cumbersome to write, read, and maintain by hand.

`ChunkSpec` provides a line-oriented, human-friendly alternative. Language developers and linguists can easily maintain intuitive rule tables and later compile them into machine-ready JSON files for production parsers.

## Goals and Non-Goals

### Goals

* **Targeted Scope**: To describe a pragmatic, limited set of grammar chunks optimized for rule-based sentence parsers.
* **Developer-Centric**: To maintain a syntax that is both exceptionally compact and highly readable for human maintainers.
* **Schema Neutral**: To remain completely independent of any specific linguistic theory or tagset. Users are free to define their own grammatical categories (e.g., tags, parts of speech, or conjugations) as needed.
* **Interoperability**: To act as an easy-to-author source format that seamlessly compiles into structured JSON.

### Non-Goals

* **Universal Coverage**: Not intended to fully map or capture the entire complexity of a human language, which is fundamentally unfeasible for static rule-based systems.
* **Deep Syntactic Parsing**: Not designed to replace full dependency treebank schema or complex generative grammars.
* **Programmable Meta-Schema Definition**: Not designed to define or modify JSON meta-schemas. The output structure (such as `pattern` and `metadata`) is hardcoded and fixed, avoiding the complexity of schema engines like JSON Schema.
* **Code-Like Control Structures**: Avoids introducing complex, code-like structures such as full regular expressions or inline executable callbacks, keeping the syntax strictly declarative and data-driven.

## Grammar & Syntax

```text
# A grammar chunk rule consists of a token sequence followed by metadata key-value pairs
<token sequence>&key1=value1&key2=value2&key3=value3;
```

* `#`: Indicates a comment line.
* `&key=value`: Standard query-string-like syntax to attach customizable metadata to the chunk.
* `;`: The end of a chunk rule.
* **Token Sequences**:
  * `<Verb:TeForm>,て,い,ます`: A sequence of tokens that forms a single grammar chunk.
  * `<Verb:TeForm>`: An abstract grammatical category (e.g., Part of Speech + Conjugation).
  * `て`, `い`, `ます`: Literal text or particles to be matched precisely.

## ChunkSpec to JSON

Given the following ChunkSpec input rule:

```text
一起,去,<Verb>&meaning=action done together&chunkType=predicate&semanticRole=adverbial
```

`ChunkSpec` processes the rule above and generates the following JSON structure:

```json
{
  "pattern": ["一起", "去", { "category": "Verb" }],
  "metadata": {
    "meaning": "action done together",
    "chunkType": "predicate",
    "semanticRole": "adverbial"
  }
}
```

Since downstream requirements vary, users need to implement their own JSON-to-JSON adapters to integrate this output into their specific projects.

## ChunkSpec to Other Formats

Currently not planned. However, an **Intermediate Representation (IR)** will be implemented for `ChunkSpec`, making future conversion to formats such as YAML, TOML, or others possible.

## Linting

`ChunkSpec` intentionally omits schema linting. If schema validation is important for your project, simply add a JSON / YAML / TOML schema linter to your pipeline.

## Language Examples

### Chinese

```text
# Adverbial indicating the desire to perform an action.
想要,去,<Verb>&meaning=want to act&chunkType=adverbial;
```

### Japanese

```text
# Polite form expressing the present continuous tense.
<Verb:Ren''youkei>,て,い,ます&meaning=be doing
&chunkType=compound_predicate&politeness=formal;
```

Single quote `'` must be escaped as `''`.

### Korean

```text
# Formal present tense ending.
<Verb|Adjective>,니다&meaning=formal present tense ending
&requireBatchim=false&fusionJamo=ㅂ&politeness=formal
&note=Attaches to verb/adjective roots without a final consonant.;
```

### English

```text
# Present future intention.
is,going,to,<Verb:BaseForm>&meaning=be going to do something&chunkType=predicate;
```

## License

Copyright (c) 2026 ByteBard. Licensed under the MIT License.

*Language is human knowledge; it neither owns copyright nor belongs to anyone.*
