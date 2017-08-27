--Nanahira & Ayane
local m=37564553
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	aux.AddXyzProcedure(c,nil,7,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(function(e)
		return e:GetHandler():IsType(TYPE_XYZ)
	end)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.cnegcon)
	e3:SetOperation(cm.cnegop)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564765,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(0x14000)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsExists(cm.sfilter,1,e:GetHandler(),tp)
	end)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.sefilter(c)
	return c:IsHasEffect(m) and c:IsFaceup()
end
function cm.cnegcon(e,tp,eg,ep,ev,re,r,rp)
	local te=Duel.IsPlayerAffectedByEffect(tp,m)
	if not te or te:GetHandler()~=e:GetHandler() then return false end
	local rc=re:GetHandler()
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and rc.Senya_desc_with_nanahira and rc:IsRelateToEffect(re)
end
function cm.cnegcon(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
	Senya.OverlayCard(e:GetHandler(),re:GetHandler())
end
function cm.sfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function cm.ssfilter(c,e,tp)
	return c:IsType(TYPE_TRAP) and c.Senya_desc_with_nanahira and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetOriginalCode(),0,0x21,7,2850,2100,RACE_FAIRY,ATTRIBUTE_LIGHT)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():GetOverlayGroup():IsExists(cm.ssfilter,1,nil,e,tp) and e:GetHandler():IsType(TYPE_XYZ) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_MZONE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gg=c:GetOverlayGroup()
	if not (c:IsRelateToEffect(e) and c:IsFaceup() and c:IsControler(tp) and not c:IsImmuneToEffect(e) and gg:IsExists(cm.ssfilter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=gg:FilterSelect(tp,cm.ssfilter,1,1,nil,e,tp):GetFirst()
	if sc then
		sc:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(sc,0x553,tp,tp,true,true,POS_FACEUP)
		sc:AddMonsterAttributeComplete()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(37564765)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end