# Scries

## %goal-update

#### `/initial`

## %goal-peek

#### `/pool-keys`

Get all the pins for all the pools.

#### `/all-goal-keys`

Get the ids for all the goals.


-----------------------

### Goal Queries

*Don't forget the sig `~` at the beginning of the pat-p `@p`: `.../~zod/...`, not `.../zod/...`.*

#### `/goal/[owner.id]/[birth.id]/get-goal`

Get the goal associated with the given id.

#### `/goal/[owner.id]/[birth.id]/get-pin`

Get the pin of the pool which contains the given goal.

#### `/goal/[owner.id]/[birth.id]/yung`

Get the goals whose deadlines immediately precede the given goal's deadline.

#### `/goal/[owner.id]/[birth.id]/yung/uncompleted`

Get the goals whose deadlines immediately precede the given goal's deadline, as long as they are uncompleted.

#### `/goal/[owner.id]/[birth.id]/yung/virtual`

Get the goals whose deadlines immediately precede the given goal's deadline, but are not in the given goals kids (ie are not "owned" by the given goal, and are thus "virtually nested")

#### `/goal/[owner.id]/[birth.id]/ryte-bound`

Get the date which bounds the given goal's deadline. Inherited from goals which the given goal precedes.

#### `/goal/[owner.id]/[birth.id]/plumb`

Get the "depth" of the given goal; the number of layers of goals "nested" beneath it (plus 1).

#### `/goal/[owner.id]/[birth.id]/priority`

Get the "priority" of the given goal; the number of goals which must be started before the given goal can started.

#### `/goal/[owner.id]/[birth.id]/seniority/[ship]/[?(%c %p)]`

Given a goal id, a ship, and either 'c' or 'p', determine the goal which gives the given ship their highest level of influence over the given goal.

#### `/goal/[owner.id]/[birth.id]/harvest`

"Harvest" the leaf goals; get goals whose deadlines precede this goal's deadline.

-----------------------

### Pool Queries

*Don't forget the sig `~` at the beginning of the pat-p `@p`: `.../~zod/...`, not `.../zod/...`.*

#### `/pool/[owner.pin]/[birth.pin]/get-pool`

Get the pool associated with the given pin.

#### `/pool/[owner.pin]/[birth.pin]/anchor`

Get the "depth" of the deepest goal in the pool; see "plumb".

#### `/pool/[owner.pin]/[birth.pin]/roots`

Get the goals in a pool whose deadlines don't immediately precede any other deadlines.

#### `/pool/[owner.pin]/[birth.pin]/roots/uncompleted`

Get the goals in a pool whose deadlines don't immediately precede any other deadlines, as long as they are uncompleted.
