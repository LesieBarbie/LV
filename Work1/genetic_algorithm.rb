# frozen_string_literal: true

class GeneticAlgorithm
  attr_reader :population, :generation, :best_solution

  def initialize(population_size, chromosome_length, mutation_rate, fitness_function)
    @population_size = population_size
    @chromosome_length = chromosome_length
    @mutation_rate = mutation_rate
    @fitness_function = fitness_function
    @population = initialize_population
    @generation = 0
    @best_solution = nil
  end

  def initialize_population
    Array.new(@population_size) { Array.new(@chromosome_length) { rand(0..1) } }
  end

  def run(generations)
    generations.times do
      fitness_scores = evaluate_fitness
      log_statistics(fitness_scores)
      @population = create_new_population(fitness_scores)
      @generation += 1
    end
    @best_solution
  end

  private

  def evaluate_fitness
    @population.map { |chromosome| @fitness_function.call(chromosome) }
  end

  def log_statistics(fitness_scores)
    # Пошук найкращого фітнесу
    best_fitness = fitness_scores.max
    average_fitness = fitness_scores.sum / fitness_scores.size.to_f
    best_chromosome = @population[fitness_scores.index(best_fitness)]

    # Оновлення найкращого рішення
    @best_solution = { chromosome: best_chromosome, fitness: best_fitness }

    # Виведення інформації про покоління
    puts "\n--- Generation #{@generation} ---"
    puts "Best Fitness: #{best_fitness}, Average Fitness: #{average_fitness}"
    puts "Population Details:"
    @population.each_with_index do |chromosome, index|
      puts "  Chromosome #{index + 1}: #{chromosome}, Fitness: #{fitness_scores[index]}"
    end
  end

  def create_new_population(fitness_scores)
    total_fitness = fitness_scores.sum
    Array.new(@population_size) do
      parent1 = select_parent(fitness_scores, total_fitness)
      parent2 = select_parent(fitness_scores, total_fitness)
      child = crossover(parent1, parent2)
      mutate(child)
    end
  end

  def select_parent(fitness_scores, total_fitness)
    pick = rand * total_fitness
    current = 0
    @population.each_with_index do |chromosome, index|
      current += fitness_scores[index]
      return chromosome if current >= pick
    end
  end

  def crossover(parent1, parent2)
    point = rand(1...@chromosome_length)
    parent1[0...point] + parent2[point...@chromosome_length]
  end

  def mutate(chromosome)
    chromosome.map { |gene| rand < @mutation_rate ? 1 - gene : gene }
  end
end
