# Unified Review Rubrics and Evaluation Criteria

Categorize and evaluate all observations, suggestions, and remediation fixes strictly against these
rubrics. If a category has no significant issues during evaluation, omit it from review feedback:

1. **Correctness and Functionality:** Does the code implement the intended logic correctly? Does it
   work as intended without introducing behavioral regressions, race conditions, or memory
   corruption? Are edge cases handled? Are there any logical flaws?

2. **DRY and Code Deduplication Across Sibling Classes:** Scrutinize newly added or modified methods
   across parallel class hierarchies or sibling override implementations for substantial copy-pasted
   algorithmic logic, refactoring into shared helpers or base methods when it genuinely reduces bug
   surface and improves clarity. Do not force premature helpers for short, self-evident idioms where
   inline code is easier to read.

3. **Testing and Testability:** Are there sufficient unit tests (positive, negative, adversarial,
   and edge cases) covering the changes? Is the code designed in a modular way that makes it easy to
   unit test? Focus on behavioral invariants, regression paths, platform-gated blocks (e.g.,
   `#ifndef NINSPECT`), and key boundaries rather than combinatorial sub-state × error-code
   permutations that bloat test files without catching distinct failure modes.

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
   introduced, check whether sibling handlers, protocol switch cases, and consumer/producer
   counterparts require the same handling. Verify that an omitted case is actually reachable under
   real protocol and caller invariants before flagging it; do not demand defensive symmetry for
   impossible states.

8. **Adversarial Input and Boundary Assertions:** Scrutinize all boundary comparisons and maximum
   type checks for mathematical precision (e.g., verifying whether strict `<` vs inclusive `<=`
   should be used against type limits). For system, network, or protocol interfaces, trace untrusted
   external peer inputs (e.g. length headers, offsets, over-the-air frames) to ensure a malicious or
   non-compliant peer cannot trigger fatal assertions, UB, or DoS loops. Distinguish untrusted
   external inputs from impossible sequences that would require a violated local hardware/kernel
   contract or ultra-narrow 3rd-order race windows whose "fix" would add more state complexity than
   risk removed.

9. **Commit Message & Document Status:** Commit message subjects should follow repository
   conventions (e.g., starting with `module: ` where required), use imperative mood (e.g., "Add
   feature", not "Added feature"), and stay within the repository's character limit (strictly under
   72 characters, or 50 in Fuchsia). The body must be written in paragraph format (plain prose
   paragraphs, without bulleted changelogs or bold section headers), outlining the problem we are
   trying to solve and what was done to solve it. Do not describe *how* it was done. The diff
   already has the implementation details.
