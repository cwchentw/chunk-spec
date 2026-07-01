# ChunkSpec

A lightweight, human-readable Domain-Specific Language (DSL) designed to describe grammar chunks in human languages.

## System Requirements

* Perl 5.36+

## Rationale

### Human Language Perspective

When describing grammar rules, linguists often need formats that are intuitive and easy to annotate. JSON or XML can feel overly rigid and verbose, obscuring the natural flow of language data.

ChunkSpec, by contrast, mirrors how humans think about language: token sequences capture stems and endings, while metadata provides semantic roles, conditions, and notes. This makes it easier to maintain grammar tables, describe particles, or even formalize punctuation as part of the rule system.

ChunkSpec is designed to capture semi‑fixed stems and endings in languages like Japanese and Korean, where naive tokenization loses meaning. By merging stems into grammar chunks with metadata, it restores linguistic insight and reflects how speakers naturally perceive grammar patterns.

### Programming Perspective

From a developer’s standpoint, JSON remains the standard for machine‑ready data. However, dense JSON files are cumbersome to hand‑edit and maintain. ChunkSpec offers a line‑oriented, human‑friendly DSL that can be compiled into JSON when needed. Its hybrid structure—token sequence plus query string metadata—keeps rules compact and readable, while still interoperating with existing parsers and toolchains.

---

In short, ChunkSpec bridges the gap between linguistic intuition and programming pragmatism, serving as both a note‑taking DSL and a compiler‑friendly format.

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

## Project Status

The core functionality is complete: happy path to JSON conversion and Markdown embedding.  
Error reporting and linting are not yet implemented.

ChunkSpec syntax is not finalized. Interested users are welcome to open Issues for discussion.  
Since this is a prototype, error reporting is missing—please file Issues if you encounter problems.

There is currently no rewrite plan, but it may eventually be rewritten in OCaml or Rust.

## Grammar & Syntax

```text
# A grammar chunk rule consists of a token sequence followed by metadata key-value pairs
<token sequence>&key1=value1&key2=value2&key3=value3;
```

### Syntax Notes

- `#`: Marks a comment line.
- `&key=value`: Query‑string style syntax for attaching metadata to a chunk.
- `;`: Indicates the end of a chunk rule.
- **Token Sequences**:
  - `<Verb:TeForm>,て,い,ます`: A sequence of tokens forming a grammar chunk.
  - `<Verb:TeForm>`: An abstract grammatical category (e.g., part of speech + conjugation).
  - `て`, `い`, `ます`: Literal text or particles that must match exactly.
- `','`: Quote‑enclosed characters are interpreted as literal text.
- `''`: Escapes a quote character itself.

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

## Embedding ChunkSpec in Markdown

ChunkSpec rules can be embedded directly inside a Markdown document using fenced code blocks. This allows the same file to serve both as human‑readable documentation and as machine‑readable corpus data.

````markdown
# Korean Sentences

```chunk
나는 대만 사람입니다.&meaning=I am Taiwanese.;
```
````

To extract and process embedded ChunkSpec rules, use the `md2chunk` tool:

```shell
$ md2chunk corpus.md
```

This command scans the Markdown file, collects all chunkspec blocks, and passes them to the standard ChunkSpec parser. The output is JSON, ready for downstream programs.

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
