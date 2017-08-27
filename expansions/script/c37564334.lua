--星痕变轨龙
local m=37564334
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	Senya.AddXyzProcedureCustom(c,cm.xyzfilter,cm.xyzcheck,2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(Senya.DescriptionCost(cm.cost))
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	e1:SetHintTiming(0,0x1e0)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(Senya.DescriptionCost())
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)>0
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
		if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(0x1fe1000+RESET_PHASE+PHASE_END)
			e1:SetValue(ct*200)
			c:RegisterEffect(e1)
		end
	end)
	e1:SetHintTiming(0,0x1e0)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,function(re,tp,cid)
		return not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL))
	end)
end
function cm.xyzfilter(c,xyzc)
	return c:GetAttribute()>0
end
function cm.xyzcheck(g)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	return tc1:IsAttribute(tc2:GetAttribute())
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.filter(c)
	return c:IsFaceup() and math.max(c:GetAttack(),0)~=math.max(c:GetBaseAttack(),0)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local atk1=math.max(tc:GetAttack(),0)
		local atk2=math.max(tc:GetBaseAttack(),0)
		local diff=math.max(atk1-atk2,atk2-atk1)
		if diff<=0 then return end
		if tc==c then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(0x1fe1000)
			e1:SetValue(function(e,c)
				return c:IsHasEffect(EFFECT_REVERSE_UPDATE) and atk2-diff or atk2+diff
			end)
			tc:RegisterEffect(e1)
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(0x1fe1000)
			e1:SetValue(atk2)
			tc:RegisterEffect(e1)
			if c:IsFaceup() and c:IsRelateToEffect(e) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(0x1fe1000)
				e1:SetValue(diff)
				c:RegisterEffect(e1)
			end
		end
	end
end