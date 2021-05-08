--ZEXAL - Zexal Weapon
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddPreDrawSkillProcedure(c,1,false,s.flipcon,s.flipop)
	aux.AddSkillProcedure(c,1,false,s.spcon,s.spop,1)
end
s.listed_names={56840427}
s.listed_series={0x107e}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return Duel.GetCurrentChain()==0
	and Duel.GetTurnPlayer()==tp
	and Duel.GetLP(tp)<=2000
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--ZeXal register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--activate
	local token=Duel.CreateToken(tp,56840427)
	Duel.SendtoDeck(token,nil,SEQ_DECKTOP,REASON_RULE)
	Duel.BreakEffect()
	--first Shining Draw because otherwise it only applies for later turns
	local g=Duel.GetDecktopGroup(tp,1)
	local sg=g:FilterSelect(tp,aux.TRUE,1,1,nil)
	--ask if you want to activate the skill or not
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_CARD,tp,id)
		local tc=sg:GetFirst()
		if tc then
			tc:ResetEffect(RESETS_REDIRECT,RESET_EVENT)
			Duel.DisableShuffleCheck()
			Duel.SendtoDeck(tc,nil,-2,REASON_RULE)
		end
		local cards={76080032,87008374,45082499,81471108,18865703,2648201,12927849}
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
		local code=Duel.SelectCardsFromCodes(tp,1,1,nil,false,table.unpack(cards))
		local token=Duel.CreateToken(tp,code)
		Duel.SendtoDeck(token,nil,SEQ_DECKTOP,REASON_RULE)
	end
	--Create Shining Draw
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1)
	e1:SetCondition(s.thcon)
	e1:SetOperation(s.thop)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	--ZeXal check
	if Duel.GetFlagEffect(ep,id)==0 then return end
	--condition
	return Duel.GetCurrentChain()==0 and tp==Duel.GetTurnPlayer()
	and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
	and Duel.GetDrawCount(tp)>0
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,1)
	local sg=g:FilterSelect(tp,aux.TRUE,1,1,nil)
	--ask if you want to activate the skill or not
	if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local tc=sg:GetFirst()
	if tc then
		tc:ResetEffect(RESETS_REDIRECT,RESET_EVENT)
		Duel.DisableShuffleCheck()
		Duel.SendtoDeck(tc,nil,-2,REASON_RULE)
	end
	local cards={76080032,87008374,45082499,81471108,18865703,2648201,12927849}
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local code=Duel.SelectCardsFromCodes(tp,1,1,nil,false,table.unpack(cards))
	local token=Duel.CreateToken(tp,code)
	Duel.SendtoDeck(token,nil,SEQ_DECKTOP,REASON_RULE)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
function s.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x107e)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	--ZeXal check
	if Duel.GetFlagEffect(ep,id)==0 then return end
	--condition
	return aux.CanActivateSkill(tp) and Duel.IsMainPhase()
	and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_FREE_CHAIN)
		e0:SetOperation(function () Duel.SetChainLimitTillChainEnd(aux.FALSE) end)
		tc:RegisterEffect(e0)
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		e0:Reset()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
