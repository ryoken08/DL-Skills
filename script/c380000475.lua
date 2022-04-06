--White Magician's Shining Shield
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.roll_dice=true
s.filter=aux.FilterFaceupFunction(Card.IsRace,RACE_SPELLCASTER)
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Roll a six-sided die twice
	local d1,d2=Duel.TossDice(tp,2)
	--Monsters your opponent controls with a Level equal to or greater than the result cannot attack during your opponent's next turn
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLevelAbove,d1+d2))
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
