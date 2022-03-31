--Phantom Strategy
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.AddSkillProcedure(c,1,false)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
s.listed_names={25542642}
s.listed_series={0x10db}
function s.counterfilter(c)
	return c:IsRankAbove(4) and not ((c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_DRAGON)) and c:IsAttribute(ATTRIBUTE_DARK))
end
function s.exfilter(c)
	return c:IsMonster() and not (c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_DARK))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return not Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK,0,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)
	end
	e:SetLabel(1)
end
function s.tgfilter(c)
	return c:IsSetCard(0x10db) and c:IsMonster()
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND,0,1,nil)
	and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Send 1 "The Phantom Knights" monster from your hand to the Graveyard
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		Duel.SendtoGrave(tc,REASON_RULE)
		if tc:IsLocation(LOCATION_REMOVED) then
			Duel.SendtoGrave(tc,REASON_RULE)
		end
	end
	Duel.BreakEffect()
	--add 1 "Phantom Knights' Fog Blade" to the very bottom of your Deck from outside of your Deck
	local token=Duel.CreateToken(tp,25542642)
	Duel.SendtoDeck(token,nil,SEQ_DECKBOTTOM,REASON_RULE)
	--Cannot Special Summon Rank 4 or above monsters except DARK Warrior-Type or DARK Dragon-Type monsters
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetTargetRange(1,0)
	e4:SetTarget(s.sumlimit)
	Duel.RegisterEffect(e4,tp)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsRankAbove(4) and not ((c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_DRAGON)) and c:IsAttribute(ATTRIBUTE_DARK))
end
