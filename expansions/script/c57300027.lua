--库拉丽丝-牡丹
local m=57300027
local cm=_G["c"..m]
function cm.initial_effect(c)
	miyuki.AddSummonMusic(c,m*16+1,SUMMON_TYPE_LINK)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x570),2,2)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC_G)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.rmcon)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(57300021)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabelObject(g)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(function(e,c)
		return e:GetHandler():GetLinkedGroup():IsContains(c) and Duel.GetFlagEffect(e:GetHandlerPlayer(),m)==0
	end)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetLabelObject(e1)
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetValue(function(e,c)
		if not c:IsType(TYPE_XYZ) or not c:IsSetCard(0x570) or Duel.GetFlagEffect(e:GetHandlerPlayer(),m)>0 then return end
		local rg=e:GetLabelObject():GetLabelObject()
		local g=c:GetMaterial()
		local check1=c:IsXyzSummonable(g,g:GetCount(),g:GetCount())
		rg:Merge(g)
		local check2=c:IsXyzSummonable(g,g:GetCount(),g:GetCount())
		rg:Clear()	
		if check1 and not check2 then
			Duel.RegisterFlagEffect(e:GetHandlerPlayer(),m,RESET_PHASE+PHASE_END,0,1)
		end 
	end)
	c:RegisterEffect(e3)
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x570) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.rmcon(e,c,og)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) and c:IsFaceup() and not c:IsDisabled() and Duel.GetMZoneCount(tp)>0
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)  
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	sg:Merge(g)
end