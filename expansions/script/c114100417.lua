--★音の妖精フォーニ
function c114100417.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_MAIN_END)
	e1:SetCost(c114100417.cost)
	e1:SetTarget(c114100417.target)
	e1:SetOperation(c114100417.activate)
	c:RegisterEffect(e1)
end
function c114100417.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c114100417.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114100417.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c114100417.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tg=g:GetFirst()
	Duel.Remove(tg,POS_FACEUP,REASON_COST)
	e:SetLabelObject(tg)
	tg:RegisterFlagEffect(114100417,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
end
function c114100417.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,114100417,0,0x21,0,0,1,RACE_FAIRY,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c114100417.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,114100417,0,0x21,0,0,1,RACE_FAIRY,ATTRIBUTE_WIND) then return end
	c:AddTrapMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_WIND,RACE_FAIRY,1,0,0)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	c:TrapMonsterBlock()
	--atklimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	--cannot be attack target (weak)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
	--cannot be effect target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3)
	--sp summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_ONFIELD) --activate as condition
	e4:SetCountLimit(1)		
	e4:SetCondition(c114100417.tgcon)
	e4:SetTarget(c114100417.tgtg)
	e4:SetOperation(c114100417.tgop)
	if Duel.GetTurnPlayer()==tp then
		e4:SetLabel(0)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	else
		e4:SetLabel(Duel.GetTurnCount())
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	end
	e4:SetLabelObject(e:GetLabelObject())
	c:RegisterEffect(e4)
end
function c114100417.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetTurnCount()~=e:GetLabel()
end
function c114100417.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c114100417.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SendtoGrave(c,REASON_EFFECT)~=0 then
			--condition
			if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)>0 then return end
			if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
			--sp summon
			local tg=e:GetLabelObject()
			if tg:GetFlagEffect(114100417)>0 and tg:IsCanBeSpecialSummoned(e,0,tp,false,false) then
				--last
				Duel.BreakEffect()
				tg:ResetFlagEffect(114100417)
				Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end


