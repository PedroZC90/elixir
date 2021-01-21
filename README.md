# elixir

Collection of elixir snippets codes

## References

-   [Elixir Lang](https://elixir-lang.org/getting-started/introduction.html)
-   [Elixir School](https://elixirschool.com/en/)
-   Book [Elixir in Action 2nd Edition](https://www.manning.com/books/elixir-in-action-second-edition)

## Notes

- reasons for running a piece of code in a dedicated server process:
    - the code must manage a long-living state.
    - the code handles a resource that can and should be reused, such as TCP connection, database connection, file handle, pipe to an OS process, and so on.
    - a critical section of the code must be synchronized. only one process may run this code in any moment.
