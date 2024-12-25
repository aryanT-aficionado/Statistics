# Visualization of Heisenberg Uncertainty Principal and Joint Density of Normal Distribution

Welcome to the festive repository filled with data visualizations that blend concepts of quantum physics and statistics with a touch of holiday cheer! 🎄✨ Below, are the details about two key visualizations that showcase fascinating concepts in visually engaging manner.

### 1️⃣ Heisenberg Uncertainty Principle Visualization

#### 🖼 Description
The plot and code illustrates the `trade-off` between `position uncertainty (Δx) and momentum uncertainty (Δp) in quantum physics`. The Heisenberg Uncertainty Principle teaches us that if we gain precision in one quantity, we lose it in the other. The Heisenberg Uncertainty Principle, which states:

- The product of uncertainties in position (Δx) and momentum (Δp) can never be smaller than a fundamental limit (h/4🥧).

In simpler terms, nature imposes a limit on how precisely we can measure these two properties simultaneously—an inherent feature of the quantum world. This visualization captures this trade-off beautifully.

###### 🎨 Key Highlights:
- **Red (Equal Δx and Δp):** Balanced uncertainties.
- **Green (High Δx, Low Δp):** High position uncertainty with precise momentum.
- **Blue (Low Δx, High Δp):** Low position uncertainty but high momentum uncertaint

The graph not only simplifies a core concept of quantum mechanics but also demonstrates the beauty of balancing trade-offs—a lesson for life and the holidays!

### 2️⃣ Joint Density of Two Normal Distributions

#### 🖼 Description
The 3D visualization explores the `joint density of two independent normal distributions (X and Y)` in a colorful, dynamic way using the vibrant color palette of `Verdis`.

###### 🎨 Key Highlights:
- The peak at the center represents the most probable values when X and Y hover near their mean (0).
- The density fades symmetrically as values deviate from the mean, capturing the essence of normality.

The graph highlights the independence of variables in a normal distribution while turning statistical concepts into a festive 3D display. Think of it as a colorful holiday tree in the world of data visualization! 🎄✨

### 3️⃣ Central Limit Theorem (CLT) Visualization

#### 🖼 Description
The project demonstrates the **Central Limit Theorem (CLT)** using a visually appealing plot. 
The CLT states that the distribution of sample means approaches a normal distribution as the sample size increases, `regardless of the shape of the original population distribution`. 
Through CLT, we can explore the fascinating transformation of sample means from `chaos to symmetry`.

#### 📊 Overview
- We start with a population generated from an **exponential distribution**—a highly skewed and non-normal distribution.
- Using repeated sampling, we calculate the mean of samples for various sample sizes (`n = 2, 5, 8, 10, 30, 50`).
- The distribution of these sample means is plotted to observe how it becomes increasingly **normal** as the sample size grows.

###### 🎨 Key Highlights:
- **Pink (2):** Small sample sizes lead to highly variable sample means.
- **Orange (5):** Slight improvement in symmetry but still erratic.
- **Yellow (8):** Beginning to see some normal characteristics.
- **Green (10):** A more defined bell shape starts to emerge.
- **Blue (30):** Almost there! Resembling the normal distribution.
- **Gold (50):** The pinnacle of order—an elegant normal curve.


### Schrodinger's Cat Theory: A Statistical Exploration

#### 🖼 Description
This project visualizes **Schrodinger's Cat Theory** through the lens of probability and the **Central Limit Theorem (CLT)**. Using a **Bernoulli distribution** to represent the dual "Alive" and "Dead" states of the cat, we examine how the probabilities evolve with an increasing number of trials.


## 📊 Overview

The experiment simulates the concept of **superposition** in quantum mechanics by assigning probabilities to the cat's "Alive" and "Dead" states. As the number of trials increases, the **CLT** ensures that the probabilities converge to normal distributions, illustrating the blending of quantum mechanics with statistical principles.

- **Biased Probability**: The "Alive" state is slightly favored with a probability of 0.53, while the "Dead" state has a probability of 0.47.
- **Dynamic Trials**: The simulation is run for varying numbers of trials `(50, 100, 250, 500, 800, 1000)` to show how the distribution evolves.
- **CLT Approximation**: The distributions are approximated using a normal distribution for both states.


###### 🎨 Key Highlights:

1. **Bernoulli Trials**
- Each trial represents a single event where the cat has a 50% chance of being "Alive" (`P = 0.5`) and 50% chance of being "Dead" (`1 - P = 0.5`).
- Simulated using the `rbinom` function in R.

2. **Central Limit Theorem**
- For a given number of trials, the sample means for "Alive" and "Dead" states are computed.
- The **CLT** approximates these sample means as normally distributed with:
  - Mean: Equal to the probability of the respective state.
  - Standard Deviation: Calculated as \( \sqrt{\frac{P \cdot (1 - P)}{n}} \), where \( n \) is the number of trials.

3. **Visual Representation**
- **Probability Density Functions (PDFs)** for "Alive" and "Dead" states are plotted for varying trial sizes (`n = 50, 100, 250, 500, 800, 1000`).
- The PDF shapes showcase the transformation of probabilities into normal distributions as trials increase.

---

## 🎨 Visualization

The plot includes:
- **X-Axis:** The continuum of "Alive" and "Dead" states.
- **Y-Axis:** Probability density values for each state.
- **Facets:** Separate panels for each trial size, showing the impact of increasing trials.
- **Color Coding:** 
  - **Red (Alive):** Represents the probability density for the "Alive" state.
  - **Blue (Dead):** Represents the probability density for the "Dead" state.

The visualization provides a conceptual demonstration of:

- The effect of bias in probabilistic systems.
- How increasing sample size reduces variability and enhances precision in statistical estimates.