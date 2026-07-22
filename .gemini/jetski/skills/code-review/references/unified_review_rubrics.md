# Unified Review Rubrics and Evaluation Criteria

Categorize and evaluate all observations, suggestions, and remediation fixes strictly against these
eight rubrics. If a category has no significant issues during evaluation, omit it from review
feedback:

1. **Correctness and Functionality:** Does the code implement the intended logic correctly? Does it
   work as intended without introducing behavioral regressions, race conditions, or memory
   corruption? Are edge cases handled? Are there any logical flaws?
2. **Testing and Testability:** Are there sufficient unit tests (positive, negative, and edge cases)
   covering the changes? Is the code designed in a modular way that makes it easy to unit test?
   Review modified unit tests with equal rigor to ensure complete testability and descriptive
  regression assertions.
3. **Readability and Maintainability:** Is the code easy to understand? Are variable, class, struct,
   and function names clear, precise, and descriptive? Is the code well-structured and organized?
   Are comments helpful and necessary without being redundant? Do the comments focus on *why* the
   code is written the way it is versus just explaining *what* it does?
4. **Efficiency and Performance:** Are there any obvious performance bottlenecks or unnecessary lock
   contention? Could algorithms or data structures be optimized?
5. **Security and Safety:** Are there any potential security vulnerabilities, buffer overflows,
   improper bounds checking, or variant/optional unpacking abort risks?
6. **Error Handling:** Is error handling robust, clear, and appropriate for embedded contexts (e.g.,
   `pw::Status`, `pw::Result`, `PW_TRY`)?
7. **Best Practices and Idiomatic Consistency:** Does the code adhere to language-specific best
   practices and project style guides (C++17 compatibility, IWYU header inclusion, C++-style headers
   like `<cstdlib>`, PEP8 for Python)? Does it consistently follow the structure and conventions of
   surrounding code? For new source files, verify that copyright headers follow project conventions
   and reflect the current year.
8. **Commit Message & Document Status:** Commit message subjects should start with the affected
   module name (top level directory) followed by a colon (e.g. `foo: add support for bar`). Commit
   messages should use imperative mood (e.g. "Add feature" not "Added feature"). The subject line
   should strictly be less than 72 characters. The body should explain the what and the why behind
   the change, not just the how.
