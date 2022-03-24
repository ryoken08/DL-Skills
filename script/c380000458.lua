--Destiny Draw: Monster Reborn
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddPreDrawSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={CARD_MONSTER_REBORN}
function s.filter(c)
	return c:IsFaceup() and c:IsAttackAbove(3000)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return Duel.GetCurrentChain()==0 and tp==Duel.GetTurnPlayer()
	and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
	and Duel.GetDrawCount(tp)>0
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,CARD_MONSTER_REBORN)
	and (Duel.GetLP(tp)<=2500 or Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil))
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	--ask if you want to activate the skill or not
	if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Your normal draw this turn will be "Monster Reborn," from your Deck
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,CARD_MONSTER_REBORN):RandomSelect(tp,1)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToDeckTop(tc)
	end
end
