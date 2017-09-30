--Nanahira the Idol
local m=37564556
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	Senya.AddSummonMusic(c,m*16+1,SUMMON_TYPE_LINK)
	--link summon
	aux.AddLinkProcedure(c,function(c) return c:GetOriginalCode()==37564765 end,1,1)
	c:EnableReviveLimit()
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetCost(Senya.DiscardHandCost(1,function(c) return c.Senya_desc_with_nanahira and c:IsType(TYPE_SPELL+TYPE_TRAP) end))
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
function cm.filter(c,e,tp,z)
	return c:IsCode(37564765) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,z)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local z=e:GetHandler():GetLinkedZone()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.filter(chkc,e,tp,z) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,z) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,z)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local z=e:GetHandler():GetLinkedZone()
	local tc=Duel.GetFirstTarget()
	if z~=0 and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,z)
	end
end