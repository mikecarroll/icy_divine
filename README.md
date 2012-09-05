# Icy_Divine

A set of Rake tools for automagically seeding ICD specifications into your Rails application. Also, a tribute to 'Pink Flamingos' lead actor [Harris Glenn Milstead (aka 'Divine')](http://en.wikipedia.org/wiki/Divine_%28actor%29), whose spirit should bring a little fresh air (and a lot of class) to the sometimes icy world of healthcare technology.

## Installation

Add this line to your application's Gemfile:

    gem 'icy_divine'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install icy_divine

### Support

Requires Ruby 1.9.2 or higher. If your app runs on an earlier version of Ruby, however, you may be able to circumvent this requirement by switching to Ruby 1.9.2 at the command line (using [RVM](https://rvm.io/), for example) before running the Rake tasks and then switching back 

Only tested with Rails 3, but should be compatible with Rails 2 as well. If you want support for another framework, or for a custom (Ruby or non-Ruby) set-up, leave an issue and I'll be happy to discuss how it might be done.

## Usage

### Super-easy (no-configuration headache) three-line set-up

The simplest way to get the full power out of this gem is to run the following commands with your Rails project folder from the command line:

```ruby
$ rails generate model Icd code:string title:string explanation:text version:string
$ rake db:migrate
$ rake icy_divine:seed
```

Presto! You'll have a new model fully seeded with the latest (2011) ICD-9 codes, including columns for the codes themselves, the code description/title, and any explanatory notes.

---

Need more? There's a couple of nifty tricks packed into the icy_divine rake task available to you to customize to get exactly what you need out of the gem:

### icy_divine:seed

A number of parameters can be passed into ivy_divine:seed, using the format

```bash
$ rake icy_divine:seed[:model, :code_attr, :description_attr, :specification, :explanation_attr, :version_attr, :reset]
```

Adding no parameters to the task, or leaving a parameter blank will run the rake task with the default parameter setting. So, if you run

```bash
$ rake icy_divine:seed[MedCodes,,,'ICD9-CM-2009']
```

The 2009 ICD9 specification will be seeded in your MedCodes model, using the default attribute names and settings.

---

Params:

- **:model** : Name of the existing model you want the codes seeded to. Default setting: 'Icd'
- **:code_attr** : Name of the existing attribute in your model where you want seed the ICD codes. Default setting: 'code'
- **:description_attr** : Name of the existing attribute in your model where you want seed the code titles/descriptions. Default setting: 'title'
- **:specification** : Name of the ICD code specification you want to seed. See below for a list of available specifications. Default setting: 'ICD9-CM-2011' (Most recent published specification.)
- **:explanation_attr** : Name of the existing attribute in your model where you want seed the code explanations. By default, explanations will NOT be seeded unless you provide an attribute name.
(NOTE: Due to the nature of the ICD code files being parsed, seeding the explanations typically triples the time/CPU required for the task to complete. Some errata in the files being parsed may require a few of the seeded explanations to pull in section to be cleaned up. Where a code does not have an explanation given, the attribute will be seeded with an empty string ('').)
- **:version_attr** : Name of the existing attribute in your model where you want seed the name of the ICD specification you are using (i.e., using specification 'ICD9-CM-2006' will seed 'ICD9-CM-2006' in attribute). By default, version name will NOT be seeded unless you provide an attribute name.
- **:reset** : By default, icy_divine will force all seeding to begin at primary key '0', overwriting any exisiting records in the model. To override this, set this parmeter to 'false' or no'.

### icy_divine:eradicate

Completely deletes all records and associations for a specified model. This is useful for testing, but not recommended for use in production.

```bash
$ rake icy_divine:eradicate[:model]
```

If a model name is not specified, the task will clear the model 'Icd', by default.

NOTE: This task will NOT reset the primary key numbering sequence for your model. If the last record in the model you just deleted had a primary key of '12427', for example, any new records added will begin at '12428'. By default, however, icy_divine:seed will reset the primary key numbering sequence to begin seeding at '0'.

## ICD Specifications

Below are the ICD specifications currently supported. All specifications are downloaded from the [Centers for Disease Control and Prevention](http://www.cdc.gov/nchs/icd/icd9cm.htm#ftp)

For further information on ICD codes, please refer to [Wikipedia](http://en.wikipedia.org/wiki/List_of_ICD-9_codes) or [World Health Organization](http://www.who.int/classifications/icd/en/).

Any help in building the 'not yet supported' features would be much appreciated (particularly for the foreign language ICD10 code versions)!

### Currently Supported
- **'ICD9-CM-2011'**
- **'ICD9-CM-2010'**
- **'ICD9-CM-2009'**
- **'ICD9-CM-2008'**
- **'ICD9-CM-2007'**
- **'ICD9-CM-2006'**
- **'ICD9-CM-2005'**
- **'ICD9-CM-2004'**
- **'ICD9-CM-2003'**
- **'ICD9-CM-2002'**
- **'ICD9-CM-2001'**
- **'ICD9-CM-2000'**
- **'ICD9-CM-1998'**
- **'ICD9-CM-1997'**

NOTE: Not all of the above specifications have been thoroughly tested. If you find an issue with one of them, please raise an issue on github.

### Not yet supported (TODO)
- **ICD10 specifications (international)** ([WHO](http://www.who.int/classifications/icd/en/))
- **ICD10 translations (Arabic, Chinese, English, French, Russian and Spanish)** ([WHO](http://www.who.int/classifications/icd/en/))
- **ICD10 specifications (all years)** ([CDC](http://www.cdc.gov/nchs/icd/icd10cm.htm))
- **ICD10 specifications (mortality only)** ([CDC](http://www.cdc.gov/nchs/icd/icd10cm.htm))

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
