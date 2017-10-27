--红之恶魔·蕾米莉亚
function c1151003.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_RELEASE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,1151003)
	e1:SetCondition(c1151003.con1)
	e1:SetTarget(c1151003.tg1)
	e1:SetOperation(c1151003.op1)
	c:RegisterEffect(e1) 
--  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1151003,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,1151004)
	e2:SetCost(c1151003.cost2)
	e2:SetTarget(c1151003.tg2)
	e2:SetOperation(c1151003.op2)
	c:RegisterEffect(e2)
--
end
--
c1151003.named_with_Leimi=1
function c1151003.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
function c1151003.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151003.cfilter1(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c1151003.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1151003.cfilter1,1,nil,tp)
end
--
function c1151003.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
--
function c1151003.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1151997,0,0x4011,200,200,1,RACE_FIEND,ATTRIBUTE_DARK) then
			local token=Duel.CreateToken(tp,1151997)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--
function c1151003.cfilter2(c)
	return c1151003.IsLeisp(c) and c:IsType(TYPE_SPELL) and c:CheckActivateEffect(true,false,false)~=nil and c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemoveAsCost()
end
function c1151003.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1151003.cfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1151003.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	local rtc=g:GetFirst()
	if rtc:IsLocation(LOCATION_GRAVE) then
		Duel.Remove(rtc,POS_FACEUP,REASON_COST)
	end
	e:SetLabelObject(rtc)
end
--
function c1151003.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetCategory(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local rtc=e:GetLabelObject()
	local te=rtc:CheckActivateEffect(true,true,false)
	Duel.ClearTargetCard()
	rtc:CreateEffectRelation(e)
	e:SetLabelObject(te)
	local tg=te:GetTarget()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
	local cg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not cg then return end
	local tc=cg:GetFirst()
	while tc do
		tc:CreateEffectRelation(te)
		tc=cg:GetNext()
	end
end
--
function c1151003.op2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te:GetHandler():IsRelateToEffect(e) then
		local cost=te:GetCost()
		if cost then 
			if cost(e,tp,eg,ep,ev,re,r,rp,0)==false then return end
			cost(e,tp,eg,ep,ev,re,r,rp,chk) 
		end
		local op=te:GetOperation()
		if op then op(te,tp,eg,ep,ev,re,r,rp) end
		local cg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if not cg then return end
		local tc=cg:GetFirst()
		while tc do
			tc:ReleaseEffectRelation(te)
			tc=cg:GetNext()
		end
	end
end