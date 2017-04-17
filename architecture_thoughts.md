

jpm-cli: Responsible for taking CLI input and preparing it for JPM

jpm: Provides the core functionalities of the package manager.

  - Local operations are performed easily
  - Proxy requests to one or more registries. Honestly I don't see how a
  courier makes this easier. Regardless we will have to define this. The
  annoying part is the interface duplication that is involved in this.

I feel like the relationship between jpm and registry are very closely coupled.
jpm does however have more responsibilities. But everything that goes in 
registry ends up going in jpm too.
