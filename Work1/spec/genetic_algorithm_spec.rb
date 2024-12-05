require_relative '../genetic_algorithm'

RSpec.describe GeneticAlgorithm do
  let(:fitness_function) { ->(chromosome) { chromosome.sum } }
  let(:algorithm) { GeneticAlgorithm.new(10, 8, 0.01, fitness_function) }

  describe '#initialize_population' do
    it 'створює популяцію правильної довжини' do
      expect(algorithm.population.size).to eq(10)
    end

    it 'створює хромосоми правильної довжини' do
      expect(algorithm.population.first.size).to eq(8)
    end

    it 'хромосоми містять лише 0 або 1' do
      expect(algorithm.population.flatten).to all(be_between(0, 1))
    end
  end

  describe '#evaluate_fitness' do
    it 'обчислює фітнес для кожної хромосоми' do
      fitness_scores = algorithm.send(:evaluate_fitness)
      expect(fitness_scores.size).to eq(10)
      expect(fitness_scores).to all(be_a(Integer))
    end

    it 'фітнес не перевищує максимальну довжину хромосоми' do
      fitness_scores = algorithm.send(:evaluate_fitness)
      expect(fitness_scores.max).to be <= 8
    end
  end

  describe '#select_parent' do
    it 'обирає батька пропорційно фітнесу' do
      algorithm.instance_variable_set(:@population, [[1, 1, 1, 1, 1, 1, 1, 1], [0, 0, 0, 0, 0, 0, 0, 0]])
      fitness_scores = [8, 0]
      total_fitness = fitness_scores.sum
      parent = algorithm.send(:select_parent, fitness_scores, total_fitness)
      expect(parent).to eq([1, 1, 1, 1, 1, 1, 1, 1])
    end

    it 'враховує випадковість у виборі батьків' do
      algorithm.instance_variable_set(:@population, [[1, 1, 1, 1, 0, 0, 0, 0], [0, 0, 0, 0, 1, 1, 1, 1]])
      fitness_scores = [4, 4]
      total_fitness = fitness_scores.sum
      parent = algorithm.send(:select_parent, fitness_scores, total_fitness)
      expect(parent).to eq([1, 1, 1, 1, 0, 0, 0, 0]).or eq([0, 0, 0, 0, 1, 1, 1, 1])
    end
  end

  describe '#crossover' do
    it 'дитина містить гени від обох батьків' do
      parent1 = [1, 1, 1, 1, 0, 0, 0, 0]
      parent2 = [0, 0, 0, 0, 1, 1, 1, 1]
      child = algorithm.send(:crossover, parent1, parent2)

      # Перевіряємо, що дитина має частини генів від обох батьків
      expect(child).to include(*parent1[0...4]).or include(*parent2[4...8])
    end

    it 'дитина має правильну довжину' do
      parent1 = [1, 1, 1, 1, 0, 0, 0, 0]
      parent2 = [0, 0, 0, 0, 1, 1, 1, 1]
      child = algorithm.send(:crossover, parent1, parent2)

      expect(child.size).to eq(8)
    end
  end

  describe '#mutate' do
    it 'виконує мутацію без зміни довжини хромосоми' do
      chromosome = [1, 0, 1, 0, 1, 0, 1, 0]
      mutated = algorithm.send(:mutate, chromosome)
      expect(mutated.size).to eq(8)
    end

    it 'не змінює гени з імовірністю мутації 0' do
      mutation_free_algorithm = GeneticAlgorithm.new(10, 8, 0, fitness_function)
      chromosome = [1, 0, 1, 0, 1, 0, 1, 0]
      mutated = mutation_free_algorithm.send(:mutate, chromosome)
      expect(mutated).to eq(chromosome)
    end

    it 'змінює деякі гени з імовірністю мутації 1' do
      always_mutating_algorithm = GeneticAlgorithm.new(10, 8, 1, fitness_function)
      chromosome = [1, 0, 1, 0, 1, 0, 1, 0]
      mutated = always_mutating_algorithm.send(:mutate, chromosome)
      expect(mutated).to eq([0, 1, 0, 1, 0, 1, 0, 1])
    end
  end

  describe '#run' do
    it 'збільшує кількість поколінь після виконання' do
      expect { algorithm.run(5) }.to change { algorithm.generation }.by(5)
    end

    it 'оновлює найкраще рішення після виконання' do
      algorithm.run(5)
      expect(algorithm.best_solution[:fitness]).to be_a(Integer)
      expect(algorithm.best_solution[:chromosome]).to be_a(Array)
    end
  end
end
