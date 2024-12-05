# Подключаем класс генетического алгоритма из существующего файла
require_relative 'genetic_algorithm'

# Функция для запроса числового ввода с валидацией
def get_number_input(prompt, min: nil, max: nil, type: :integer)
  loop do
    print prompt
    input = gets.chomp
    value = type == :integer ? input.to_i : input.to_f
    if (!min || value >= min) && (!max || value <= max)
      return value
    else
      puts "Ошибка: введите число#{min ? " не меньше #{min}" : ""}#{max ? " и не больше #{max}" : ""}."
    end
  end
end

# Главная программа
def main
  puts "Добро пожаловать в программу Генетического Алгоритма!"

  loop do
    # Меню
    puts "\nМеню:"
    puts "1. Запустить генетический алгоритм"
    puts "2. Выход"
    choice = get_number_input("Выберите пункт меню (1 или 2): ", min: 1, max: 2)

    if choice == 2
      puts "До свидания! 👋"
      break
    end

    # Запуск генетического алгоритма
    run_genetic_algorithm
  end
end

# Функция для выполнения генетического алгоритма
def run_genetic_algorithm
  # Получение пользовательских параметров
  population_size = get_number_input("Введите размер популяции: ", min: 1)
  chromosome_length = get_number_input("Введите длину хромосомы: ", min: 1)
  mutation_rate = get_number_input("Введите вероятность мутации (от 0 до 1): ", min: 0, max: 1, type: :float)
  generations = get_number_input("Введите количество поколений: ", min: 1)

  # Выбор функции приспособленности
  puts "\nВыберите функцию приспособленности:"
  puts "1. Максимизация суммы битов (1 -> лучше)"
  puts "2. Минимизация суммы битов (0 -> лучше)"
  fitness_function = case get_number_input("Ваш выбор (1 или 2): ", min: 1, max: 2)
                     when 1
                       lambda { |chromosome| chromosome.sum }
                     when 2
                       lambda { |chromosome| chromosome.length - chromosome.sum }
                     end

  # Создание и запуск генетического алгоритма
  ga = GeneticAlgorithm.new(
    population_size,
    chromosome_length,
    mutation_rate,
    fitness_function
  )

  puts "\n🔄 Запуск генетического алгоритма...\n"
  puts "Начальная популяция:"
  ga.population.each_with_index do |chromosome, index|
    puts "  Индивид #{index + 1}: #{chromosome.join}"
  end
  puts "\n"

  generations.times do |generation|
    puts "=== Поколение #{generation + 1} ==="

    # Этап 1: Оценка приспособленности
    fitness_scores = ga.send(:evaluate_fitness)
    puts "🔍 Оценка приспособленности:"
    ga.population.each_with_index do |chromosome, index|
      puts "  Индивид #{index + 1}: #{chromosome.join} => Приспособленность = #{fitness_scores[index]}"
    end

    # Этап 2: Логирование статистики
    ga.send(:log_statistics, fitness_scores)

    # Этап 3: Отбор, скрещивание и мутация
    puts "\n🔄 Создание новой популяции:"
    new_population = []
    fitness_scores.sum.tap do |total_fitness|
      ga.population.size.times do
        parent1 = ga.send(:select_parent, fitness_scores, total_fitness)
        parent2 = ga.send(:select_parent, fitness_scores, total_fitness)
        child = ga.send(:crossover, parent1, parent2)
        mutated_child = ga.send(:mutate, child)

        new_population << mutated_child
        puts "  Родитель 1: #{parent1.join}"
        puts "  Родитель 2: #{parent2.join}"
        puts "  Потомок до мутации: #{child.join}"
        puts "  Потомок после мутации: #{mutated_child.join}\n"
      end
    end
    ga.instance_variable_set(:@population, new_population)
  end

  # Финальный результат
  puts "\n🎉 Алгоритм завершён!"
  best_solution = ga.best_solution
  puts "Лучшее найденное решение:"
  puts "Хромосома: #{best_solution[:chromosome].join}"
  puts "Приспособленность: #{best_solution[:fitness]}"
end

# Запуск программы
main
