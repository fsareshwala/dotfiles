# Unified Review Rubrics and Evaluation Criteria

Categorize and evaluate all observations, suggestions, and remediation fixes strictly against these
rubrics. If a category has no significant issues during evaluation, omit it from review feedback:

1. **Correctness and Functionality:** Does the code implement the intended logic correctly? Does it
   work as intended without introducing behavioral regressions, race conditions, or memory
   corruption? Are edge cases handled? Are there any logical flaws?

2. **DRY and Code Deduplication Across Sibling Classes:** Scrutinize newly added or modified methods
   across parallel class hierarchies or sibling override implementations for copy-pasted algorithmic
   logic. Demand immediate refactoring into shared private helpers, anonymous namespace functions, or
   base class methods when identical calculation or byte-clamping blocks are detected.

3. **Testing and Testability:** Are there sufficient unit tests (positive, negative, adversarial,
   and edge cases) covering the changes? Is the code designed in a modular way that makes it easy to
   unit test? When caching or state retention mechanisms are introduced, ensure tests verify
   mid-transaction state changes.

4. **Readability and Maintainability:** Is the code easy to understand? Are variable, class, struct,
   and function names clear, precise, and descriptive? Is the code well-structured and organized?
   Do comments focus on *why* the code is written the way it is versus just explaining *what* it
   does?

5. **Efficiency and Performance:** Are there any obvious performance bottlenecks or unnecessary lock
   contention? Could algorithms or data structures be optimized? Ensure repetitive continuation
   queries cannot force expensive database re-evaluations or redundant computations.

6. **Error Handling & Embedded Best Practices:** Is error handling robust, clear, and appropriate
   for embedded contexts? Does the code adhere to project style guides (C++17 compatibility, IWYU
   header inclusion, C++-style headers like `<cstdlib>`, PEP8 for Python)? For core embedded paths,
   does the code avoid dynamic memory allocation?

7. **Symmetric Architecture and Pattern Completeness:** Whenever a defensive design pattern, caching
   mechanism, state tracker, or performance optimization (e.g. DoS mitigation, rate limiting) is
   introduced, verify that it is applied symmetrically across all sibling handlers, protocol switch
   cases, and related data structures. Actively query: *If this pattern or defensive feature applies
   to Cases A and B, why was Case C omitted?*

8. **Adversarial Input and Boundary Assertions:** Scrutinize all boundary comparisons and maximum
   type checks for mathematical precision (e.g., verifying whether strict `<` vs inclusive `<=`
   should be used against type limits). For system, network, or protocol interfaces, trace untrusted
   external peer inputs (e.g. length headers, offsets) to prove that a malicious peer cannot trigger
   fatal assertions or DoS resource starvation loops.

9. **Commit Message & Document Status:** Commit message subjects should start with the affected
   module name followed by a colon (e.g. `foo: add support for bar`). Commit messages should use
   imperative mood (e.g. "Add feature" not "Added feature") and stay strictly under 72 characters.
   The body should explain the *what* and *why* behind the change, not just the *how*.
