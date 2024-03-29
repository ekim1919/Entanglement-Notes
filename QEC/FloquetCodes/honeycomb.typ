#import "personal_thm_envs.typ": *


= Definitions

We begin with the "original" Floquet code defined by Hastings and Haah over a _periodic_ honeycomb lattice. The honeycomb lattice is defined as seen in @honeycomb_lattice.

#figure(
    image("figures/honeycomb_lattice.png", width:50%),
    caption: [The honeycomb lattice]
) <honeycomb_lattice>

 - The qubits are placed on the vertices and each vertex is adjacent to exactly three edges.
 - The hexagonal plaquettes are colored/labeled such that no two neighboring plaquettes sharing an edge are labeled the same. Here, we label the faces with types $0,1,2$.
 - The edges are labeled with a Pauli flavor and a type label.
    - The edge's type label is determined by the type of the faces which the edge connects. For example, the thicker horizontal line in @honeycomb_lattice is labeled type $0$ as it connects two faces of type 0.
    - The Pauli flavor is determined by the orientation of the edge as shown in the top left corner of @honeycomb_lattice.

The checks of the code will be the the weight-two Pauli operators supported on the vertices of each edge. Furthermore, the checks will be measured in particular order: $0,1,2 mod 3$. This measurement sequence will continue and repeat periodically. This ordering is quite crucial to the integrity of the dynamically generated logical qubits existing at any point during the measurement schedule.

= Empty as Subsystem Code

Recall that we can define a subsystem code by considering a set of Pauli product operators as "gauge checks" and generating a group from those checks called the "gauge group". The stabilizer group of the subsystem code will be the center of that gauge group. The non-trivial logical operators will be those which commute with the gauge group but are not contained in the stabilizer group. To see that this code is trivial as a subsystem code:

    + Note that if there are $n_f$ faces, then there are $n_v = 2n_f$ vertices (There are 6 vertices for each hexagonal face, but by the 3-valency of the graph, each vertex will be counted precisely 3 time).
    + Also, there will be $n_e = 3n_f$ edges. (A similar argument as above but each edge will be counted exactly twice).
    + However, there is a redundency in the number of checks as the product of all checks will equal the identity up to a global phase. To see this, note by the edge labelings each vertex particiaptes in three checks of differing Pauli flavors. Hence, multiplying the checks will result in $X Y Z = i I$ up to a sign for each vertex. By periodicity, the total product must result in the identity operator over all qubits. Hence, there are $n_f - 1$ check generators.
    + Direct inspection shows that the stabilizer group is generated by the product of checks over a single face. This looks something like @honeycomb_stab

#figure(
    image("figures/honeycomb_stab.png", width:30%),
    caption: [The stabilizers as a product of the check operators bordering the face.]

)<honeycomb_stab>

Products of these stabilizers correspond to homologically trivial cycles along the honeycomb lattice. Due to the periodic boundary conditions, there are two homologically non-trivial cycles: one oriented vertically and the other oriented horizontally. These can be thought of cycles which wrap along different directions of the torus. As these cycles can be expressed as products of the checks, they are contained inside the stabilizer group. This yields $n_f + 2$. However, once again the product of all these stabilizers will equal the identity. Thus, the total number of linearly independent generators is actually $n_f + 1$.

Then how many gauge qubits will there be? Well, there are two logical operators for each gauge qubit so there must be $ n_g =frac((3n_f - 1) - (n_f - 1),  2) = n_f - 1 $
Since there are $n_s = n_f + 1$ stabilizers, $ n_s + n_g = (n_f + 1) + (n_f - 1) = 2n_f = n_v $
This shows that as a subsystem code this code does not support any logical qubits.

#remark[I actually don't really fully get the reasoning behind this. I should really familiarize myself with subsystem formalism.]

= Instataneous Stabilizer Groups (ISGs)

Now that we know how the checks and stabilizers are defined, how do we initialize this code? Furthermore, if the code cannot support any logical qubits as a subsystem code, then how do we generate logical qubits in first place? The answers lie in the Instantaneous Stabilizer Groups (ISGs) associated to every measurement round.

Let us first run the measurement schedule assuming an uninitalized state over the qubits. Following the notation in the paper, denote $cal(S)(r)$ to be the ISG over the qubits after the $r^("th")$ round's measurements. This would be after measuring the type $r mod 3$ checks.

#remark[It will be important to remember that any plaquette stabilizer will commute with all checks as a closed loop of products of checks.]

/ Round 0: $cal(S)(0)$ will simply contain all of the type 0 checks
/ Round 1: $cal(S)(1)$ will contain all of the type 1 checks and the type 2 plaquettes. To see why, observe from @honeycomb_lattice that the type 2 faces are bordered by type 0,1 edges. The type 0 edges will be coalesced into a single stabilizer and the type 1 checks will be inserted into the ISG. By multiplying these type 1 edges into the merged type 0 stabilizer, we get the type 2 face. For each type 2 face, these operations can be done without interface from other type 2 faces. See @round1_isg for a little picture.

#figure(
    image("figures/round1_isg.png",width:55%)
) <round1_isg>



/ Round 2: $cal(S)(2)$ will by a similar argument above contain both the type 2 checks and the type 0 checks. As the type 2 face stabilizers commute with all checks, it will also contain the type 2 faces.

/ Round $r gt.eq 3$: $cal(S)(r)$ will contain all of the type 0,1,2 face stabilizer as well as the type $r mod 3$ checks. This can be seen by noting that the procedure above does not generate new linearly independent elements due to the addition of all the face stabilizers.


A crucial property behind the initialization of the ISG is that the checks of $r+1 mod 3$ anti-commute with the checks of $r mod 3$ in such a way that face stablizers are added into the ISG without the measurement schedule accidently measuring a homologically non-trivial cycle. In fact, measuring the $x,y,z$ Paulis periodically in that order would introduce a such a non-trivial cycle traveling vertically across the lattice.

How many logical qubits does this code support at round $r$? Since the face stablizers commute with all checks, they will always be contained within the $cal(S)(r)$ for all $r gt.eq 3$. The product of all these face stabilizers yields a linear dependence. Hence, there are $n_f -1$ linearly independent stabilizer generators. Also, there are $n_f$ type $r mod 3$ edges contained in the ISG, and the product of the type $r mod 3$ face stabilizers with the type $r mod 3$ edges will result in the identity. This shows that the total number of linearly independent stabilizer generators to be $(n_f - 1) + (n_f - 1) = 2n_f - 2$. As there are $2n_f$ qubits, there must be 2 logical qubits.
