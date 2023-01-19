#!/usr/bin/env ruby

# file: gems_deplevel.rb

require 'gems'
require 'dir-to-xml'


class GemDepLevelErr < Exception
end

class GemsDepLevel

  def initialize(dir=nil, debug: false)
    @dir, @debug = dir, debug
  end

  # Returns the dependency depth level for a gem's transitive dependencies
  #
  # * gemlist contains the a list gem names, each containing the
  #   gem dependencies
  #
  #    - use gem_deps() to make the gemlist or scan_gems() if using a
  #      local gem_src directory
  #
  #
  def dep_level(name, gemlist=gem_deps(name))

    raise GemDepLevelErr, 'supply the name of a gem' unless name

    gemtally = Hash.new(0)
    scan(name, gemlist, gemtally)

    gemtally.sort_by(&:last).group_by(&:last).map do |key, value|
      [key, value.map(&:first)]
    end.to_h

  end

  # returns a Hash object of transitive gem dependencies for a specific gem
  # [{gem name => [gem1, gem2, ...]}, {gem1 => [gem1.1, gem1.2]}]
  #
  def gem_deps(name)

    return unless name

    puts 'name: ' + name.inspect if @debug
    gem = Gems.info name

    a = gem['dependencies']['runtime'].map {|x| x['name']}
    h = {name => a}

    a.inject(h) do |r,x|
      puts 'r.keys: ' + r.keys.inspect if @debug
      r.keys.include?(x) ? r : r.merge!(gem_deps(x))
    end

  end


  # Returns the dependencies for each gem as a Hash object
  #
  def scan_gems(dir=@dir)

    raise GemDepLevelErr, 'please provde a directory path' unless dir

    dtx = DirToXML.new dir
    names = dtx.directories

    gems = names.map do |name|

      gemspec = File.join(dir, "#{name}/#{name}.gemspec")

      if File.exist? gemspec then

        s = File.read gemspec
        dependencies = s.scan(/add_runtime_dependency\(['"]([^'"]+)/)
                              .map(&:first)

        [name, dependencies]

      else
        nil
      end

    end

    return Hash[gems.compact]

  end

  private

  # the return value is passed back through gemtally
  #
  def scan(gem, h, gemtally=Hash.new(0), level=0)

    if @debug then
      puts 'inside scan'
      puts 'gem; ' + gem.inspect
      puts 'h: ' + h.inspect
    end

    return unless h.include? gem

    gemtally[gem] = level if gemtally[gem] <= level

    h[gem].each {|x| scan(x, h, gemtally, level+1) }

  end

end
