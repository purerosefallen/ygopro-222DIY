--3L·少女密室
local m=37564830
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--Senya.CommonEffect_3L(c,m)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
end
function cm.effect_operation_3L(c,ctlm)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(ctlm)
	e2:SetCost(Senya.DescriptionCost())
	e2:SetCondition(function(e,tp)
		return not Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,0,1,nil)
	end)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2,true)
	return e2
end
function cm.filter1(c)
	return c:IsFaceup() and c:IsCode(m+1)
end
function cm.filter2(c,tp)
	return c:IsAbleToRemoveAsCost() and Duel.IsExistingTarget(cm.filter3,tp,LOCATION_MZONE,0,1,nil,c)
end
function cm.filter3(c,tc)
	return c:IsFaceup() and Senya.check_set_3L(c) and c:IsType(TYPE_MONSTER) and Senya.EffectSourceFilter_3L(tc,c)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter3(chkc,e:GetLabelObject()) end
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_GRAVE,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),tp)
	local tc=rg:GetFirst()
	rg:AddCard(e:GetHandler())
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter3,tp,LOCATION_MZONE,0,1,1,nil,tc)
	Duel.SetTargetParam(tc:GetOriginalCode())
	e:SetLabelObject(tc)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local cd=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and cd then
		Senya.GainEffect_3L(tc,cd,2)
	end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,0x4011,800,1000,1,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetMZoneCount(tp)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,0x4011,800,1000,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,m+1)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(37564800)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1,true)
		local t=Senya.GetGainedList_3L(c)
		local chk=false
		for i,cd in pairs(t) do
			if cd~=m then
				Senya.GainEffect_3L(token,cd)
				chk=true
			end
		end
		local copym=c:GetFlagEffectLabel(37564820)
		if copym then
			local copyt=Senya.order_table[copym]
			for i,dt in pairs(copyt) do
				token:CopyEffect(dt.ccode,RESET_EVENT+0x1fe0000)
			end
			chk=true
		end
		if chk then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e2,true)
		end
		Duel.SpecialSummonComplete()
	end
end