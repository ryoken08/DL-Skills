--Harpies' Hunting Ground
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.AddPreDrawSkillProcedure(c,1,false,s.condition,s.activate)
end
s.listed_names={75782277}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return Duel.GetCurrentChain()==0 and tp==Duel.GetTurnPlayer()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--activate only in your first turn
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.flipcon)
	e1:SetOperation(s.flipop)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsMainPhase() and not Duel.CheckPhaseActivity()
	and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,75782277)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--return 1 card from your hand to your Deck
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
	--if you control a Field Spell, place it in the Graveyard
	local g1=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if g1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetReset(RESET_CHAIN)
		g1:RegisterEffect(e1)
		g1:ResetEffect(RESETS_REDIRECT,RESET_EVENT)
		Duel.SendtoGrave(g1,REASON_RULE)
		if g1:IsLocation(LOCATION_REMOVED) then
			Duel.SendtoGrave(g1,REASON_RULE)
		end
	end
	--place 1 "Harpies' Hunting Ground" to your Field Zone from your Deck
	local tc=Duel.GetFirstMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,nil,75782277)
	Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
end
