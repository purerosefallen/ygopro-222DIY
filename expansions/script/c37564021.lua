--蔷薇的统领者
local m=37564021
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_elem=true
cm.Senya_name_with_kana=true
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--特招方法
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(1)
	--e2:SetCountLimit(1,m1+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--变超量
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37564765,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC_G)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(SUMMON_TYPE_XYZ)
	e2:SetCondition(cm.rmcon)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
end
function cm.spfilter1(c)
	return Senya.check_set_rose(c) and c:IsAbleToRemoveAsCost() 
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.spfilter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil)
	return Duel.GetLocationCountFromEx(tp)>0
		and g:GetClassCount(Card.GetCode)>=5
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.spfilter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil)
	local tg=Group.CreateGroup()
	for i=1,5 do	 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		tg:Merge(sg)
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
	end
	Duel.Remove(tg,POS_FACEUP,REASON_COST)
end
function cm.matfilter(c)
	return c:IsType(TYPE_XYZ) and Senya.check_set_elem(c)
end
function cm.filter(c,e,tp)
	return Senya.check_set_elem(c) and e:GetHandler():IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(cm.matfilter,tp,LOCATION_EXTRA,0,1,c) and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(e:GetHandler()),c)>0
end
function cm.rmcon(e,c,og)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and c:IsFaceup() and not c:IsDisabled() and c:GetOriginalCode()==m and Senya.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)  
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg2=Duel.SelectMatchingCard(tp,cm.matfilter,tp,LOCATION_EXTRA,0,1,3,sc)
	Senya.OverlayGroup(e:GetHandler(),mg2,true,true)
	mg2:AddCard(e:GetHandler())
	sc:SetMaterial(mg2)
	Senya.OverlayCard(sc,e:GetHandler(),true,true)
	sg:AddCard(sc)
	local e1=Effect.CreateEffect(sc)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetReset(0xfe1000)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(function(e)
		e:GetHandler():CompleteProcedure()
		e:Reset()
	end)
	sc:RegisterEffect(e1,true)
end