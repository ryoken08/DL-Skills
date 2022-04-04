--Out of Control!
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddPreDrawSkillProcedure(c,1,false,s.flipcon,s.flipop)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={79850798,24731453,51126152,56910167,97520701}
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		--add cards from outside of the deck to the deck
		Duel.Hint(HINT_CARD,tp,id)for i=1,3 do
			local token=Duel.CreateToken(tp,s.listed_names[i])
			Duel.SendtoDeck(token,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		end
		local token2=Duel.CreateToken(tp,56910167)
		Duel.SendtoDeck(token2,nil,SEQ_DECKTOP,REASON_RULE)
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	end
	e:SetLabel(1)
end
function s.filter(c)
	return c:IsMonster() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevel(10) 
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return Duel.GetCurrentChain()==0 and tp==Duel.GetTurnPlayer()
	and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
	and Duel.GetDrawCount(tp)>0
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,2,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	--ask if you want to activate the skill or not
	if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--your normal draw becomes "Special Schedule" from outside of your Deck
	local token=Duel.CreateToken(tp,97520701)
	Duel.SendtoDeck(token,nil,SEQ_DECKTOP,REASON_RULE)	
end
