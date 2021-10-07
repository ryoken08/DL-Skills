--Pendulum Shuffle
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.GetFieldCard(tp,LOCATION_PZONE,0) and Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,2,nil)
end
function s.move_to_pendulum_zone(c,tp,e)
	if not c or not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--place all cards in your Pendulum Zones face-up on your Extra Deck
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_PZONE,0,nil)
	Duel.SendtoExtraP(g,tp,REASON_RULE)
	--place in your Pendulum Zones 2 random face-up Pendulum Monsters from your Extra Deck
	local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_EXTRA,0,nil)
	local rg=sg:RandomSelect(tp,2)
	if #rg==2 then
		Duel.BreakEffect()
		s.move_to_pendulum_zone(rg:GetFirst(),tp,e)
		s.move_to_pendulum_zone(rg:GetNext(),tp,e)
	end
end
