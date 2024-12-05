require_relative '../genetic_algorithm'

RSpec.describe GeneticAlgorithm do
  let(:fitness_function) { ->(chromosome) { chromosome.sum } }
  let(:algorithm) { GeneticAlgorithm.new(10, 5, 0.01, fitness_function) }

  it 'initializes population with correct size' do
    expect(algorithm.population.size).to eq(10)
    expect(algorithm.population.first.size).to eq(5)
  end

  it 'evaluates fitness correctly' do
    fitness_scores = algorithm.send(:evaluate_fitness)
    expect(fitness_scores).to all(be_a(Integer))
    expect(fitness_scores.max).to be <= 5
  end

  it 'performs crossover correctly' do
    parent1 = [1, 1, 1, 1, 1]
    parent2 = [0, 0, 0, 0, 0]
    child = algorithm.send(:crossover, parent1, parent2)
    expect(child.size).to eq(5)
    expect(child).to include(1).or(include(0))
  end

  it 'performs mutation correctly' do
    chromosome = [1, 0, 1, 0, 1]
    mutated = algorithm.send(:mutate, chromosome)
    expect(mutated.size).to eq(5)
  end

  it 'runs the algorithm and finds a solution' do
    result = algorithm.run(20)
    expect(result[:fitness]).to be_a(Integer)
    expect(result[:chromosome]).to be_a(Array)
  end
end