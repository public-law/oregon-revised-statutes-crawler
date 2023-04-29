[![Elixir CI](https://github.com/public-law/oregon-revised-statutes-crawler/actions/workflows/elixir.yml/badge.svg)](https://github.com/public-law/oregon-revised-statutes-crawler/actions/workflows/elixir.yml)

# Oregon Revised Statutes Crawler

Using [the Crawly framework](https://github.com/elixir-crawly/crawly) to parse
the [Oregon Revised Statutes ("ORS")](https://www.oregonlegislature.gov/bills_laws/Pages/ORS.aspx) into well formed JSON.

The output contains one line per statute object:

```json
{"number":"1","name":"Courts, Oregon Rules of Civil Procedure","kind":"volume","chapter_range":["1","55"]}
{"number":"2","name":"Business Organizations, Commercial Code","kind":"volume","chapter_range":["56","88"]}
{"number":"3","name":"Landlord-Tenant, Domestic Relations, Probate","kind":"volume","chapter_range":["90","130"]}
```

etc.

We've made the data from the last run available here: https://github.com/public-law/datasets/blob/master/UnitedStates/Oregon

## To run the spider

``` bash
iex -S mix run -e "Crawly.Engine.start_spider(Spider)"
```

## To auto-run tests

```bash
fswatch lib test | mix test --listen-on-stdin
```

### Clear before each run

```bash
fswatch lib test | xargs -I {} sh -c 'clear && mix test'
```
