--元素掌握者·Ayane
local m=37564011
local cm=_G["c"..m]

xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_elem=true
function cm.initial_effect(c)
	--xyz summon
	Senya.AddXyzProcedureRank(c,4,nil,2,63)
	--不会成为攻击效果对象
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.con)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.con)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
		--吸收素材
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--特招
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,m-4000)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.thcon)
	e4:SetOperation(cm.operation2)
	c:RegisterEffect(e4)
end
function cm.cfilter2(c)
	return c:IsType(TYPE_XYZ) and c:GetOriginalRank()==4
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(cm.cfilter2,1,nil)
end
function cm.filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetRank()==4
		and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and cm.filter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,e:GetHandler(),tp)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Senya.OverlayCard(c,tc)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(cm.filter7,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0
end
function cm.filter7(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:GetRank()==4 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	local ft=Duel.GetMZoneCount(tp)
	local g1=e:GetHandler():GetOverlayGroup()
	local sg=g1:Filter(cm.filter7,nil,e,tp)
	if ft==0 or sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local mg=sg:Select(tp,ft,ft,nil)
	local fid=e:GetHandler():GetFieldID()
	e:GetHandler():RegisterFlagEffect(m-4000,RESET_EVENT+0x1fe0000,0,1,fid)
	for tc in aux.Next(mg) do
		Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1,fid)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		tc:CompleteProcedure()
	end
	Duel.SpecialSummonComplete()
	mg:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(mg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(cm.retop)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCountLimit(1)
	e2:SetLabel(fid)
	e2:SetLabelObject(mg)
	e2:SetOperation(cm.desop)
	e:GetHandler():RegisterEffect(e2,true)
end
function cm.retfilter(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffectLabel(m-4000)~=e:GetLabel() then return end
	c:ResetFlagEffect(m-4000)
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.retfilter,nil,e:GetLabel())
	Senya.OverlayGroup(c,tg)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.retfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end