--White Magician's Defensive Spell
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
s.roll_dice=true
s.filter=aux.FilterFaceupFunction(Card.IsRace,RACE_SPELLCASTER)
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--twice per duel check
	if Duel.GetFlagEffect(ep,id)>1 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--flag register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Roll a six-sided die twice
	local d1,d2=Duel.TossDice(tp,2)
	local res=d1+d2
	local def=0
	if res==2 then
		def=1000
	elseif (res==3 or res==4 or res==5 or res==6 or res==7) then
		def=700
	elseif (res==8 or res==9 or res==10 or res==11) then
		def=500
	elseif res==12 then
		def=100
	end
	--Decrease DEF of all monsters your opponent controls
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-def)
		tc:RegisterEffect(e1)
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
