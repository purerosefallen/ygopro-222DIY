--苍空的舞姬·纱由里
local m=37564325
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(0x14000)
	e1:SetCondition(Senya.SummonTypeCondition(SUMMON_TYPE_RITUAL))
	e1:SetTarget(cm.atktg)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SET_BASE_ATTACK)
	e4:SetCondition(cm.adcon)
	e4:SetValue(cm.atkval)
	e4:SetLabelObject(e1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SET_BASE_DEFENSE)
	e5:SetCondition(cm.adcon)
	e5:SetValue(cm.defval)
	e5:SetLabelObject(e1)
	c:RegisterEffect(e5)
	Senya.NegateEffectModule(c,1,nil,function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:GetEquipGroup():IsExists(Card.IsAbleToGraveAsCost,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=c:GetEquipGroup():FilterSelect(tp,Card.IsAbleToGraveAsCost,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,0,0,0)
end
function cm.rmfilter(c)
	return c:IsAbleToChangeControler() and c:IsType(TYPE_MONSTER)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_GRAVE,nil)
	local ct=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),g:GetCount())
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local fg=Group.CreateGroup()
	local sg=g:Select(tp,ct,ct,nil)
	local check=false
	for tc in aux.Next(sg) do
		if Duel.Equip(tp,tc,c,true) then
			check=true
			tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(function(e,c)
				return e:GetOwner()==c
			end)
			tc:RegisterEffect(e1)
		else
			fg:AddCard(tc)
		end
	end
	if check then
		Duel.EquipComplete()
		sg:Sub(fg)
		sg:KeepAlive()
		e:SetLabelObject(sg)
	end
end
function cm.afilter(c)
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:GetFlagEffect(m)>0
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():GetLabelObject()
	return g and g:IsExists(cm.afilter,1,nil)
end
function cm.valc(c,f)
	return math.max(f(c),0)
end
function cm.atkval(e,c)
	return e:GetLabelObject():GetLabelObject():Filter(cm.afilter,nil):GetSum(cm.valc,Card.GetTextAttack)
end
function cm.defval(e,c)
	return e:GetLabelObject():GetLabelObject():Filter(cm.afilter,nil):GetSum(cm.valc,Card.GetTextDefense)
end