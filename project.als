// 1. structure of the social network, includes users and friendships
sig User {
	friends: User
}
abstract sig Content {
	ownedBy: one User,
	ViewPrivacy: one PrivacyLevel,
       CommentPrivacy: one PrivacyLevel
}
sig Note extends Content {
	contains : some Photo,
	associatedWith : some Tag
}
sig Photo extends Content {
	associatedWith : some Tag
}
sig Comment extends Content {
	attachedTo: one Content
}

sig Tag {
	// reference to only one user
	// can only be added to photo or note
	reference: one User
}

sig Wall {
	// belongs to a user
	// have many notes and photos
}

sig Nicebook {
	contents: User -> Content,
	walls: User->Wall,
	comments: Content -> Comment, // attached comments
	tags: Content -> Tag // must be with an constraint: no Comment -> Tag exists
	published: Wall -> Content,
       wallPrivacy: Wall -> Privacy
}

abstract sig PrivacyLevel{}

one sig OnlyMe, Friends, FriendsOfFriends, Everyone extends PrivacyLevel{}

// publish a piece of content on a user’s wall. The content may be the existing one. 
pred publish [u : User, c : Content, n,n' : Nicebook] {
	n'.walls = n.walls
}

// hide a piece of content on a user’s wall
pred unpublish [] {
	// only the owner can hide the content on his/her wall
}

// Upload a piece of content, excluding the attacked comments
pred upload [b, b': Nicebook, u: User, c: Content] {
	// precondition
	// the content doesn't exist
	c not in b.contents[u]

	// postcondition
	// the content belongs to the user
	c in b'.contents[u]
	// the privacy level is Everyone
	c.ViewPrivacy = Everyone
	// the content is shown on the user's wall
	c in b'.walls[u].published
}

// Remove an existing piece of content from a user’s account.
pred remove [b, b': Nicebook, u: User, c: Content] {
	// precondition
	// the content must belong to the user
	c in b.contents[u]

	// postcondition
	// remove the attached comments
	b'.comments[c] = none
	// remove the tags
	b'.tags[c] = none
	// remove the content form the user
	c not in b'.contents[u]
	// remove the content form the wall
	c not in b'.walls[u]
}

// Add a comment to a content.
pred addComment [b, b': Nicebook, u: User, comment: Comment, content: Content] {
	// precondition
	// the comment doesn't exist
	comment not in b.comments[content]
	// authorized to add comment to the content
	// TODO from Olivia

	// postcondition
	// the comment must belong to the user
	comment in b'.contents[u]
	// the comment is attached to the content
	comment in b'.comments[content]
}
run{}for 3 but exactly 5 Content


/*abstract sig PrivacyLevel {}
one OnlyMe, Friends, FriendsOfFriends, Everyone extends PrivacyLevel {}

// 2. operations for modifying user content

// upload a piece of content, photo, comment, or note
pred upload [] {
// only the owner or owner’s friends can post notes or photos
}

// add a comment to an existing photo, note, or another comment
pred addComment [] {
	// only viewable content to a user can be added comment
}


// add a tag to a note or photo
pred addTag [] {
	// the content should publish on the wall of the tagged user
}

// remove a tag on a note or photo
pref removeTag[] {
}

pred removeTag [] {}


// 3. Privacy setting that control access to those content

fun viewable [u: User] {
	// return the content that can be viewed by the user
}

assert NoPrivacyViolation {
	// violation occurs if a user is able to see content not in `viewable`
}*/

pred invariants{
	// if u1 is a friend of u2, then u2 is also a friend of u1
	all u1,u2 : User | u1 != u2 and u1 in u2.friends implies u2 in u1.friends
	// users and content are belongs to only one social network

        // all c : Content | one (Content.ownedBy) // specify in Content.ownedBy
}
