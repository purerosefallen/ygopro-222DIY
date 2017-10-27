--Nanahira & Kana
local m=37564535
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
cm.Senya_name_with_kana=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	c:EnableReviveLimit()
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_SINGLE)
	e22:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e22:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e22)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564765,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.bmrlcon)
	e1:SetOperation(cm.bmrlop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564765,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(function(e,c)
		if c==nil then return true end
		return Duel.GetMZoneCount(c:GetControler())>0 and c:GetFlagEffect(m)>0
	end)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp)
		return Duel.GetTurnPlayer()~=tp
	end)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.operation1)
	c:RegisterEffect(e1)
end
function cm.bmrlfilter(c,ft)
	if ft==0 and c:GetSequence()>4 then return false end
	return c:IsCode(37564765) and bit.band(c:GetType(),0x8020d0+TYPE_LINK)~=0
end
function cm.bmrlcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetMZoneCount(tp)
	return ft>-1 and Duel.CheckReleaseGroup(tp,cm.bmrlfilter,1,nil,ft)
end
function cm.bmrlop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetMZoneCount(tp)
	local g=Duel.SelectReleaseGroup(tp,cm.bmrlfilter,1,1,nil,ft)
	Duel.Release(g,REASON_COST)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
		end
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetRange(LOCATION_ONFIELD)
		e4:SetCode(EVENT_CHAIN_END)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		e4:SetOperation(cm.rmop)
		tc:RegisterEffect(e4)
		if c:IsFaceup() and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetRange(LOCATION_ONFIELD)
			e1:SetCode(EVENT_CHAIN_END)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetOperation(cm.rmop)
			c:RegisterEffect(e1,true)
		end
	end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and Duel.SendtoGrave(c,REASON_EFFECT)>0 then
		c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
	end
	e:Reset()
end