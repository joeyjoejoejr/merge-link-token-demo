## Running
### Multi-tenant
```
bundle
API_KEY=some-api-key bundle exec ruby app.rb
```

### Single-tenant
This is specific to oyster's single tenant
```
bundle
API_KEY=some-api-key TENANT=1 bundle exec ruby app.rb
```

Navigate to localhost:4567
