--Neo Sylvio
local s,id=GetID()
function s.initial_effect(c)
	--Skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={99940363,26822796}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(Card.IsSummonType,tp,LOCATION_MZONE,0,1,nil,SUMMON_TYPE_TRIBUTE)
	and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,nil,TYPE_SPELL+TYPE_TRAP)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Change 1 Spell/Trap Card in your hand to a different card
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		local code=nil
		if tc:IsType(TYPE_SPELL) then
			code=99940363
		elseif tc:IsType(TYPE_TRAP) then
			code=26822796
		end
		tc:Recreate(code,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
	end
end
