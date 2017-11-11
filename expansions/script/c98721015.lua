--娱乐奥义 翠玉
function c98721015.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c98721014.matfilter,2,2)
	--ret&draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(581014,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c581014.target)
	e1:SetOperation(c581014.operation)
	c:RegisterEffect(e1)
end
c98721014.em=true
function c98721014.isem(c)
	local m=_G["c"..c:GetCode()]
	return m and m.em
end
function c98721014.matfilter(c)
	return c98721014.isem(c) and c:GetLink()<2
end
