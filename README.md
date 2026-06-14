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
<token sequence>&key1=value1&key2=value2&key3=value3
```

* `#`: Indicates a comment line.
* `&key=value`: Standard query-string-like syntax to attach customizable metadata to the chunk.
* **Token Sequences**:
  * `<Verb:TeForm>,て,い,ます`: A sequence of tokens that forms a single grammar chunk.
  * `<Verb:TeForm>`: An abstract grammatical category (e.g., Part of Speech + Conjugation).
  * `て`, `い`, `ます`: Literal text or particles to be matched precisely.

---

## ChunkSpec to JSON

Given the following ChunkSpec input rule:

```text
# DSL Source Example
一起,去,<Verb>&meaning=together action&chunkType=predicate&semanticRole=adverbial
```

Depending on the `@mode` directive, the parser outputs the structure in either a nested or an unnested format:

### Layered Mode (`@mode=layered`)

This mode separates the structural syntax pattern from its semantic properties, keeping metadata neatly encapsulated.

```json
{
  "pattern": ["一起", "去", { "category": "Verb" }],
  "metadata": {
    "meaning": "together action",
    "chunkType": "predicate",
    "semanticRole": "adverbial"
  }
}
```

### Flat Mode (`@mode=flat`)

This mode flattens the metadata properties directly into the root object, which can be useful for simple key-value lookups or database storage.

```json
{
  "pattern": ["一起", "去", { "category": "Verb" }],
  "meaning": "together action",
  "chunkType": "predicate",
  "semanticRole": "adverbial"
}
```

## Language Examples

### Chinese

```text
# Adverbial indicating the desire to perform an action.
想要,去,<Verb>&meaning=want to act&chunkType=adverbial
```

### Japanese

```text
# Polite form expressing the present continuous tense.
<Verb:Ren'youkei>,て,い,ます&meaning=be doing&chunkType=compound_predicate&politeness=formal
```

### Korean

```text
# Formal present tense ending.
<Verb|Adjective>,니다&meaning=formal present tense ending&requireBatchim=false&fusionJamo=ㅂ&politeness=formal&note=Attaches to verb/adjective roots without a final consonant.
```

### English

```text
# Present future intention.
is,going,to,<Verb:BaseForm>&meaning=be going to do something&chunkType=predicate
```

## License

Copyright (c) 2026 ByteBard. Licensed under the MIT License.

*Language is human knowledge; it neither owns copyright nor belongs to anyone.*
