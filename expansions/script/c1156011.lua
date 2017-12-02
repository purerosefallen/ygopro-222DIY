--未确认幻想飞行少女
function c1156011.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1156011.lkcheck,3,3,c1156011.lcheck)
--  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1156011,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,1156011)
	e1:SetCost(c1156011.cost1)
	e1:SetTarget(c1156011.tg1)
	e1:SetOperation(c1156011.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c1156011.con2)
	e2:SetOperation(c1156011.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1156011,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,1156011)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c1156011.tg3)
	e3:SetOperation(c1156011.op3)
	c:RegisterEffect(e3)
--
end
--
function c1156011.lkcheck(c)
	return c:IsType(TYPE_MONSTER) and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_FUSION) or (c:IsType(TYPE_LINK) and c:GetLink()>1)) 
end
function c1156011.lcheck(g)
	return g:GetClassCount(Card.GetCode)==g:GetCount() 
end
--
function c1156011.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(1156011,0x1fe1000+RESET_CHAIN,0,1)
end
--
function c1156011.tfilter1(c,e,tp)
	return c:IsFacedown() and c:IsCanBeSpecialSummoned(e,0,tp,false,true) and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c)>0 and (((c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_FUSION)) and c:GetLevel()<7) or (c:IsType(TYPE_XYZ) and c:GetRank()<7) or (c:IsType(TYPE_LINK) and c:GetLink()<4)) and not c:IsCode(1156011)
end
function c1156011.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1156011.tfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
--
function c1156011.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1156011.tfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,true,POS_FACEUP) then
			local e1_1=Effect.CreateEffect(e:GetHandler())
			e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e1_1:SetValue(1)
			tc:RegisterEffect(e1_1,true)
			if e:GetHandler():GetFlagEffect(1156011)>0 then
				e:GetHandler():SetCardTarget(tc)
				e:SetLabelObject(tc)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
--
function c1156011.con2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c1156011.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--
function c1156011.tfilter3(c)
	return c:IsType(TYPE_MONSTER)
end
function c1156011.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c1156011.tfilter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1156011.tfilter3,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c1156011.tfilter3,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
end
--
function c1156011.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local code=tc:GetOriginalCode()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e3_1=Effect.CreateEffect(c)
		e3_1:SetType(EFFECT_TYPE_SINGLE)
		e3_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3_1:SetCode(EFFECT_CHANGE_CODE)
		e3_1:SetValue(code)
		c:RegisterEffect(e3_1)
		c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	end
end
--
