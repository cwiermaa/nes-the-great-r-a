# Enemy Workflow

This document outlines the steps required to add a new enemy to the project.

---

## Steps

1. **Create Enemy File**

   * Open `TemplateEnemy.asm`
   * Rename the label to match the enemy name
   * Save the file as `<enemy_name>.asm`

2. **Register the Enemy**

   * Include the new file in the project
   * Add a pointer to the enemy in the pointer list within `AI.asm`

3. **Create Visual Assets**

   * Define sprite map(s) for the enemy
   * Create animation strip(s)

4. **Register Animations**

   * Add the animation strip(s) to the appropriate slot in `Animations.asm`

5. **Define Gameplay Properties**

   * Add entries in `EnemyScores.asm` for:

     * Health
     * Damage on contact
     * Score value
