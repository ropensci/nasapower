# PowerSDI

<details>

* Version: 1.0.0
* GitHub: https://github.com/gabrielblain/PowerSDI
* Source code: https://github.com/cran/PowerSDI
* Date/Publication: 2024-01-15 11:20:02 UTC
* Number of recursive dependencies: 83

Run `revdepcheck::revdep_details(, "PowerSDI")` for more info

</details>

## Newly broken

*   checking tests ...
    ```
      Running ‘testthat.R’
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
        7.         └─nasapower::get_power(...)
        8.           └─nasapower:::.send_query(.query_list = query_list, .url = power_url)
        9.             └─client$get(query = .query_list, retry = 6L, timeout = 30L)
       10.               └─private$make_request(rr)
       11.                 └─adap$handle_request(opts)
       12.                   └─private$request_handler(req)$handle()
       13.                     └─eval(parse(text = req_type_fun))(self$request)
       14.                       └─err$run()
       15.                         └─self$construct_message()
      
      [ FAIL 9 | WARN 0 | SKIP 0 | PASS 89 ]
      Deleting unused snapshots:
      • PlotData/disp-plotdata-a.svg
      Error: Test failures
      Execution halted
    ```

